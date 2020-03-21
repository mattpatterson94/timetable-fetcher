require_relative 'config'
require_relative 'api'

module Kaya
  class Fetcher
    def initialize(options)
      @options = options
    end

    def fetch
      monday = monday_in_week(date).strftime('%d-%m-%Y')

      html = api.get(location, monday)

      parser.new(html).parse
    end

    private

    attr_reader :options

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

    def config
      @config ||= Kaya::Config
    end
  end
end
