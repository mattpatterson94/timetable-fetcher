# frozen_string_literal: true
module Kaya
  class Config
    KAYA_HOST = 'timetables.kayahealthclubs.com.au'

    KAYA_LOCATIONS = {
      prahran: '1',
      emporium: '2'
    }.freeze

    KAYA_STUDIOS = %w[
      yoga_studio
      group_x_studio
      grc_1_studio
      grc_2_studio
      mind_body
    ].freeze

    class << self
      def studios
        KAYA_STUDIOS
      end

      def default_location
        KAYA_LOCATIONS[:emporium]
      end

      def get_location(location)
        KAYA_LOCATIONS[location.to_sym]
      end

      def host
        KAYA_HOST
      end
    end
  end
end
