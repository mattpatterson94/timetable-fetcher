# frozen_string_literal: true

require_relative 'fetcher'
require_relative 'parser'

module Kaya
  module Factory
    def self.build_kaya_options(option_parser, options)
      option_parser.on('--kaya-location=KAYA_LOCATION', 'The Kaya Location to fetch the timetable for') do |location|
        options[:kaya_location] = location
      end

      option_parser.on('--kaya-date=KAYA_DATE', 'The date to fetch the timetable for. eg. 20-03-2020') do |date|
        options[:kaya_date] = date
      end
    end

    def build_kaya_fetcher
      Kaya::Fetcher.new(kaya_options)
    end

    private

    def kaya_options
      @kaya_options ||= {
        parser: Kaya::Parser,
        location: options[:kaya_location],
        date: options[:kaya_date]
      }
    end
  end
end
