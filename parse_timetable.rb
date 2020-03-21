#!/usr/bin/env ruby

# frozen_string_literal: true

require 'nokogiri'
require 'open-uri'
require 'date'

KAYA_HOST = 'timetables.kayahealthclubs.com.au'

KAYA_LOCATIONS = {
  prahran: '1',
  emporium: '2'
}.freeze

KAYA_STUDIOS = %w[
  yoga_studio
  group_x_studio
  grc_1_studio
  grc_2_studio
  mind_body
].freeze

def this_monday(date)
  expected_monday = date

  expected_monday = expected_monday.prev_day until expected_monday.monday?

  expected_monday.strftime('%d-%m-%Y')
end

def kaya_timetable_url(location, start_date)
  query_params = [
    '_en=view_timetable',
    "location=#{location}",
    "start_date=#{start_date}"
  ]

  URI::HTTPS.build(
    host: KAYA_HOST,
    path: '/index.php',
    query: query_params.join('&')
  ).to_s
end

location = ARGV[0] ? KAYA_LOCATIONS[ARGV[0].to_sym] : KAYA_LOCATIONS[:emporium]
monday_date = ARGV[1] || this_monday(Date.today)

kaya_timetable = Nokogiri::HTML(URI.open(kaya_timetable_url(location, monday_date)))

KAYA_STUDIOS.each do |studio|
  # => Times for studio: Yoga studio
  puts "Times for studio: #{studio.tr('_', ' ').capitalize}"

  current_studio = kaya_timetable.css("div[data-studio=\"#{studio}\"]")

  times_table = current_studio.css('> table')[1]
  times_table_rows = times_table.css('> tr')

  dates = times_table_rows[0]
  days = times_table_rows[1]

  # This goes down the table and gets each class per time.
  # eg first row is every class through the week at 7:00am
  times_table_rows[2...times_table_rows.length].each do |classes_at_time|
    class_columns = classes_at_time.css('> td')
    class_time = class_columns[0].css('span').text

    class_columns[1...class_columns.length].each_with_index do |studio_class, index|
      class_date = dates.css('td')[index + 1].css('span').text
      class_day = days.css('td')[index].css('span')&.text
      class_table = studio_class.css('table')

      # if no class is on
      next if class_table.empty?

      instructor = class_table.css('tr')[0].css('td p').text
      class_type = class_table.css('tr')[1].css('td p').text

      # => 19 March Thursday - 6:45pm: Reformer with Caitlin
      puts "#{class_date} #{class_day} - #{class_time}: #{class_type} with #{instructor}"
    end
  end
end
