# frozen_string_literal: true
module Kaya
  class Config
    KAYA_HOST = 'timetables.kayahealthclubs.com.au'
    KAYA_TIMEZONE = 'Australia/Melbourne'

    KAYA_LOCATIONS = {
      prahran: '1',
      emporium: '2'
    }.freeze

    KAYA_STUDIOS = {
      yoga_studio: 'Yoga',
      group_x_studio: 'Group X',
      grc_1_studio: 'Pilates (GCR 1)',
      grc_2_studio: 'Pilates (GCR 2)',
      mind_body: 'Pilates (GCR 3)'
    }.freeze

    class << self
      def studios
        KAYA_STUDIOS
      end

      def default_location
        KAYA_LOCATIONS[:emporium]
      end

      def timezone
        KAYA_TIMEZONE
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
