# frozen_string_literal: true

require 'optparse'
require 'etc'
require_relative 'shot_format'
require_relative 'long_format'

class LsCommand
  attr_reader :argv

  def initialize(argv)
    optionparser = OptionParser.new
    @option = {}
    optionparser.on('-a') { |v| @option[:a] = v }
    optionparser.on('-r') { |v| @option[:r] = v }
    optionparser.on('-l') { |v| @option[:l] = v }
    optionparser.parse(argv)
  end

  def result
    @option.include?(:l) ? LongFormat.new(current_items) : ShotFormat.new(current_items)
  end

  def current_items
    current_items =
      if @option.include?(:a)
        Dir.glob('*', File::FNM_DOTMATCH)
      else
        Dir.glob('*')
      end

    @option.include?(:r) ? current_items.reverse : current_items
  end
end
