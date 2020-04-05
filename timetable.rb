#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'src/timetable_options'
require_relative 'src/timetable_fetcher'
require_relative 'src/timetable_logger'

begin
  logger = TimetableLogger
  options = TimetableOptions.new.build_options
  timetable = TimetableFetcher.new(options).fetch

  case options[:format]
  when 'stdin'
    logger.print(timetable.to_s)
  when 'json'
    logger.print(timetable.to_json)
  else
    logger.print(timetable.to_s)
  end
rescue FetcherError => e
  logger.print("There was an error fetching the Timetable: #{e.message}")
  exit
rescue UnsupportedPlaceError => e
  logger.print("#{e.message}:\n#{options[:place]}")
  exit
end
