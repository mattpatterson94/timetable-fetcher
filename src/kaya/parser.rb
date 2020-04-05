# frozen_string_literal: true

require 'date'
require 'tzinfo'
require_relative 'html'
require_relative 'config'

module Kaya
  class Parser
    def initialize(html, monday_date, collection, item_class)
      @html = html
      @monday_date = monday_date
      @collection = collection
      @item_class = item_class
    end

    def parse!
      studios.keys.map(&:to_s).each do |studio|
        kaya_html.classes_from_studio(studio) do |classes|
          classes.each do |timetable_class|
            kaya_class = item_class.new(
              datetime: parse_datetime(timetable_class),
              type: type_without_time_override(timetable_class[:type].strip),
              instructor: timetable_class[:instructor],
              studio: studio
            )

            collection.add_to_collection(kaya_class)
          end
        end
      end
    end

    private

    attr_reader :html, :monday_date, :collection, :item_class

    def studios
      config.studios
    end

    def kaya_html
      @kaya_html ||= Kaya::Html.new(html)
    end

    def parse_datetime(timetable_class)
      class_time = class_time_override(timetable_class)
      offset = class_timezone_offset(timetable_class[:date]) # eg. +1000
      # We grab the year from the request because it isn't specified in the timetable
      DateTime.parse("#{timetable_class[:date]} #{monday_date.year} #{class_time} #{offset}")
    end

    # Sometimes the class time is in the "type" field.
    # This is because it doesn't always start when the rest of the classes do
    def class_time_override(timetable_class)
      override = timetable_class[:type].match(/^(.*[ap][m])/).to_a[0]

      return timetable_class[:time] if override.nil?

      override
    end

    # eg.   9:15am Reformer with Ali
    # =>    Reformer with Ali
    def type_without_time_override(type)
      type.gsub(/^(.*[ap][m]\s)/, '')
    end

    # eg. +1100 for Melbourne
    def class_timezone_offset(date)
      offset = timezone.period_for(DateTime.parse(date)).observed_utc_offset / 36
      offset_indicator = offset.positive? ? '+' : '-'

      "#{offset_indicator}#{offset.abs}"
    end

    def timezone
      @timezone ||= TZInfo::Timezone.get(config.timezone)
    end

    def config
      @config ||= Kaya::Config
    end
  end
end
