require_relative '../timetable_item'
require_relative 'config'

module Kaya
  class Item < TimetableItem
    def datetime
      @datetime ||= item_details[:datetime]
    end

    def type
      @type ||= item_details[:type]
    end

    def formatted_date
      datetime.strftime('%A %d %B')
    end

    def formatted_time
      datetime.strftime('%l:%M%P')
    end

    def studio
      config.studios[item_details[:studio].to_sym] || 'Other'
    end

    def instructor
      item_details[:instructor]
    end

    def to_s
      # => 5:15pm: Reformer with Caitlin
      "#{formatted_time}: #{type} with #{instructor}"
    end

    def to_h
      {
        datetime: datetime.to_s,
        instructor: instructor,
        studio: studio,
        type: type
      }
    end

    private

    def config
      @config ||= Kaya::Config
    end
  end
end
