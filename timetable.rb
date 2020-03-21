#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'timetable_options'
require_relative 'timetable_fetcher'
require_relative 'logger'

begin
  options = TimetableOptions.new.build_options
  timetable = TimetableFetcher.new(options).fetch

  case options[:format]
  when 'stdin'
    Logger.print(timetable.to_s)
  when 'json'
    Logger.print(timetable.to_json)
  else
    Logger.print(timetable.to_s)
  end
rescue UnsupportedPlaceError => e
  puts "#{e.message}: #{options[:place]}"
  exit
end
