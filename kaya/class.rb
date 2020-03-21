require_relative '../timetable_class'

module Kaya
  class Class < TimetableClass
    def date
      class_details[:date]
    end

    def instructor
      class_details[:instructor]
    end

    def type
      class_details[:type]
    end
  end
end
