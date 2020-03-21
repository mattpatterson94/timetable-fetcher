# frozen_string_literal: true

require 'nokogiri'

require_relative 'config'

module Kaya
  class Parser
    def initialize(html)
      @html = html
    end

    def parse
      studios.each do |studio|
        # => Times for studio: Yoga studio
        puts "Times for studio: #{studio.tr('_', ' ').capitalize}"

        current_studio = parsed_html.css("div[data-studio=\"#{studio}\"]")
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
    end

    private

    attr_reader :html

    def studios
      config.studios
    end

    def parsed_html
      @parsed_html ||= Nokogiri::HTML(html)
    end

    def config
      @config ||= Kaya::Config
    end
  end
end
