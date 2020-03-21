# frozen_string_literal: true

require_relative 'timetable_place'
require_relative 'timetable_factory'
require_relative 'timetable_collection'

class TimetableFetcher
  def initialize(options, collection_klass = TimetableCollection)
    @options = options
    @collection_klass = collection_klass
  end

  def fetch
    fetcher.fetch
  end

  private

  attr_reader :options, :collection_klass

  def fetcher
    @fetcher ||= begin
      raise UnsupportedPlaceError unless timetable_place.supported?

      factory.send("build_#{timetable_place}_fetcher")
    end
  end

  def factory
    @factory ||= TimetableFactory.new(options, collection)
  end

  def collection
    @collection ||= collection_klass.new
  end

  def timetable_place
    @timetable_place || TimetablePlace.new(options[:place])
  end
end

class UnsupportedPlaceError < StandardError
  def message
    'The place you provided is unsupported'
  end
end

# ci step to build kaya timetable json and store in s3 | dropbox
# build proxy to pull from DB if no domain whitelisting
# heroku hobby with nginx | docker. nginx proxies to docker
# heroku hosts both proxy and site

# check s3 website costs
# check s3 data transfer costs for storing timetable
# maybe we can build the chrome into a service worker
# maybe we can use lambda for proxy
# md5 class id (timestamp + class + instructor?)
