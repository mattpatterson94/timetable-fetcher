class TimetableCollection
  def add_to_collection(timetable_class)
    classes << timetable_class
  end

  def all
    classes
  end

  private

  def classes
    @classes ||= []
  end
end
