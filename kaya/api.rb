# frozen_string_literal: true

require 'open-uri'
require_relative 'config'

module Kaya
  class Api
    GET_PARAM_DEFAULTS = ['_en=view_timetable'].freeze

    def get(location, monday_date)
      query_params = GET_PARAM_DEFAULTS + [
        "location=#{location}",
        "start_date=#{monday_date}"
      ]

      url = URI::HTTPS.build(
        host: host,
        path: '/index.php',
        query: query_params.join('&')
      ).to_s

      URI.open(url)
    end

    private

    def config
      @config ||= Kaya::Config
    end

    def host
      @host ||= config.host
    end
  end
end
