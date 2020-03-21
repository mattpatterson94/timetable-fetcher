#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'timetable_options'
require_relative 'timetable_fetcher'
require_relative 'timetable_printer'

begin
  options = TimetableOptions.new.build_options
  timetable = TimetableFetcher.new(options).fetch
  TimetablePrinter.new(timetable).print
rescue UnsupportedPlaceError => e
  puts "#{e.message}: #{options[:place]}"
  exit
end
