require 'optparse'
require_relative 'timetable_factory'

class TimetableOptions
  def build_options
    option_parser.parse!
    options
  end

  private

  def option_parser
    @option_parser ||= OptionParser.new do |opts|
      opts.banner = 'Usage: timetable.rb [options]'

      opts.on('-pPLACE', '--place=PLACE', 'The place to fetch the timetable for') do |place|
        options[:place] = place
      end

      timetable_factory.build_options(opts, options)

      opts.on('-h', '--help', 'Prints this help') do
        puts opts
        exit
      end
    end
  end

  def timetable_factory
    @timetable_factory ||= TimetableFactory
  end

  def options
    @options ||= {}
  end
end
