require 'nokogiri'

module Kaya
  class Html
    def initialize(html)
      @html = html
    end

    def get_classes_by_studio(studio, &block)
      times_table = get_times_table(studio)

      dates = times_table[:date_columns]
      # This goes down the table and gets each class per time.
      # eg first row is every class through the week at 7:00am
      classes = times_table[:class_rows].map do |class_row|
        classes_at_time = get_class_row(class_row)
        class_time = classes_at_time[:time]

        classes_at_time[:classes].each_with_index.map do |studio_class, index|
          kaya_class = get_class(studio_class)
          class_date = get_class_date(dates, index)

          next if kaya_class.nil?

          {
            date: class_date,
            time: class_time,
            type: kaya_class[:type],
            instructor: kaya_class[:instructor]
          }
        end
      end.flatten.compact

      block.call(classes)
    end

    private

    attr_reader :html

    def get_times_table(studio)
      studio_block = parsed_html.css("div[data-studio=\"#{studio}\"]")
      times_table = studio_block.css('> table')[1]
      times_table_rows = times_table.css('> tr')

      {
        date_columns: times_table_rows[0],
        class_rows: times_table_rows[2...times_table_rows.length]
      }
    end

    def get_class_row(class_row_block)
      class_columns = class_row_block.css('> td')
      class_time = class_columns[0].css('span').text
      classes_at_time = class_columns[1...class_columns.length]

      {
        time: class_time,
        classes: classes_at_time
      }
    end

    def get_class_date(dates, index)
      dates.css('td')[index + 1].css('span').text
    end

    def get_class(class_block)
      class_table = class_block.css('table')

      # if no class is on
      return nil if class_table.empty?

      instructor = class_table.css('tr')[0].css('td p').text
      class_type = class_table.css('tr')[1].css('td p').text

      {
        instructor: instructor,
        type: class_type
      }
    end

    def parsed_html
      @parsed_html ||= Nokogiri::HTML(html)
    end
  end
end
