# frozen_string_literal: true
require 'json'
require_relative '../timetable_collection'

module Kaya
  class Collection < TimetableCollection
    def all
      items.sort_by { |item| [item.datetime, item.formatted_date] }
    end

    def to_s
      print = []

      per_date(all) do |date, date_classes|
        print << "\n#{date}"

        per_studio(date_classes) do |studio, studio_classes|
          print << "|-- #{studio}"

          studio_classes.each do |kaya_class|
            print << "|-- |-- #{kaya_class}"
          end
        end
      end

      print.join("\n")
    end

    def to_json(*args)
      JSON.pretty_generate(
        { classes: all.map(&:to_h) },
        args
      )
    end

    def per_studio(items, &block)
      grouped_items = items.group_by(&:studio)

      grouped_items.sort.each(&block)
    end

    def per_date(items, &block)
      grouped_items = items.group_by(&:formatted_date)

      grouped_items.each(&block)
    end
  end
end
