# frozen_string_literal: true

require_relative 'timetable_place'
require_relative 'timetable_factory'

class TimetableFetcher
  def initialize(options)
    @options = options
  end

  def fetch
    fetcher.fetch
  end

  private

  attr_reader :options

  def fetcher
    @fetcher ||= begin
      raise UnsupportedPlaceError unless timetable_place.supported?

      factory.send("build_#{timetable_place}_fetcher")
    end
  end

  def factory
    @factory ||= TimetableFactory.new(options)
  end

  def timetable_place
    @timetable_place || TimetablePlace.new(options[:place])
  end
end

class FetcherError < StandardError; end
class UnsupportedPlaceError < StandardError
  def message
    'The place you provided is unsupported.'
  end
end
