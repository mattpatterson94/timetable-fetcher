# frozen_string_literal: true

class TimetableCollection
  def add_to_collection(timetable_item)
    items << timetable_item
  end

  protected

  def items
    @items ||= []
  end
end
