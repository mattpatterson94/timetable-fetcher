class TimetablePrinter
  def initialize(timetable)
    @timetable = timetable
  end

  def print
    @timetable.all.each do |timetable_class|
      puts "#{timetable_class.date}: #{timetable_class.type} with #{timetable_class.instructor}"
    end
  end
end
