# frozen_string_literal: true

require_relative 'html'
require_relative 'config'

module Kaya
  class Parser
    def initialize(html, date, collection, class_klass)
      @html = html
      @date = date
      @collection = collection
      @class_klass = class_klass
    end

    def parse!
      studios.each do |studio|
        kaya_html.get_classes_by_studio(studio) do |classes|
          classes.each do |timetable_class|
            kaya_class = class_klass.new(
              date: timetable_class[:date],
              type: timetable_class[:type],
              instructor: timetable_class[:instructor],
            )

            collection.add_to_collection(kaya_class)
          end
        end
      end
    end

    private

    attr_reader :html, :date, :collection, :class_klass

    def studios
      config.studios
    end

    def kaya_html
      @kaya_html ||= Kaya::Html.new(html)
    end

    def config
      @config ||= Kaya::Config
    end
  end
end
