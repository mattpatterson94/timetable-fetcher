require 'date'
require_relative 'config'
require_relative 'api'

module Kaya
  class Fetcher
    def initialize(options, collection_class, item_class)
      @options = options
      @collection_class = collection_class
      @item_class = item_class
    end

    def fetch
      monday = monday_in_week(date)

      html = api.get(location, monday)

      parser.new(html, monday, collection, item_class).parse!

      collection
    end

    private

    attr_reader :options, :collection_class, :item_class

    def monday_in_week(date)
      return date if date.monday?

      monday_in_week(date.prev_day)
    end

    def api
      @api ||= Kaya::Api.new
    end

    def date
      @date ||= options[:date] ? Date.parse(options[:date]) : Date.today
    end

    def location
      @location ||= config.get_location(options[:location]) || config.default_location
    end

    def parser
      @parser ||= options[:parser]
    end

    def collection
      @collection ||= collection_class.new
    end

    def config
      @config ||= Kaya::Config
    end
  end
end
