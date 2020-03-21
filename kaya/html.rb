require 'nokogiri'

module Kaya
  class Html
    def initialize(html)
      @html = html
    end

    def classes_from_studio(studio, &block)
      times_table = times_table_from_studio(studio)
      dates_row = times_table[:dates_row]

      classes = times_table[:time_rows].map do |time_row|
        find_all_classes_at_time(time_row, dates_row)
      end

      classes.flatten!
      classes.compact!

      block.call(classes)
    end

    private

    attr_reader :html

    def times_table_from_studio(studio)
      studio_block = parsed_html.css("div[data-studio=\"#{studio}\"]")
      times_table = studio_block.css('> table')[1]
      times_table_rows = times_table.css('> tr')

      {
        dates_row: times_table_rows[0],
        time_rows: times_table_rows[2...times_table_rows.length]
      }
    end

    def find_all_classes_at_time(time_row, dates_row)
      classes_at_time = class_columns(time_row)
      class_time = classes_at_time[:time]

      classes_at_time[:class_columns].each_with_index.map do |class_column, index|
        class_details(
          class_column,
          index,
          class_time,
          dates_row
        )
      end
    end

    def class_columns(class_row_block)
      class_columns = class_row_block.css('> td')
      class_time = class_columns[0].css('span').text
      classes_at_time = class_columns[1...class_columns.length]

      {
        time: class_time,
        class_columns: classes_at_time
      }
    end

    def class_date(dates, index)
      dates.css('td')[index + 1].css('span').text
    end

    def class_details(class_column, index, class_time, dates_row)
      class_table = class_column.css('table')

      # if no class is on
      return nil if class_table.empty?

      {
        date: class_date(dates_row, index),
        time: class_time,
        instructor: class_table.css('tr')[0].css('td p').text,
        type: class_table.css('tr')[1].css('td p').text
      }
    end

    def parsed_html
      @parsed_html ||= Nokogiri::HTML(html)
    end
  end
end
