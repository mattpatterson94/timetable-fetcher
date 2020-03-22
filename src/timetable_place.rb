# frozen_string_literal: true

class TimetablePlace
  SUPPORTED_PLACES = %w[kaya].freeze

  def initialize(place)
    @place = place
  end

  def to_s
    place
  end

  def supported?
    SUPPORTED_PLACES.include? place
  end

  private

  attr_reader :place
end
