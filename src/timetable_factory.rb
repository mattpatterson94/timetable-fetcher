# frozen_string_literal: true

require_relative 'kaya/factory'

class TimetableFactory
  class << self
    def build_options(option_parser, options)
      Kaya::Factory.build_kaya_options(option_parser, options)
    end
  end

  include Kaya::Factory

  def initialize(options)
    @options = options
  end

  private

  attr_reader :options
end
