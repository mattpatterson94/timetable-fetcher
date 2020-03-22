class TimetableItem
  def initialize(item_details)
    @item_details = item_details
  end

  protected

  attr_reader :item_details
end
