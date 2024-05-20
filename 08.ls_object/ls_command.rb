# frozen_string_literal: true

require 'optparse'
require 'etc'
require_relative 'short_formatter'
require_relative 'long_formatter'

class LsCommand
  def initialize(argv)
    optionparser = OptionParser.new
    @options = {}
    optionparser.on('-a') { |v| @options[:a] = v }
    optionparser.on('-r') { |v| @options[:r] = v }
    optionparser.on('-l') { |v| @options[:l] = v }
    optionparser.parse(argv)
  end

  def show
    @options.include?(:l) ? formatter.print_repeat_file_detail : formatter.puts_file_names
  end

  private

  def formatter
    @options.include?(:l) ? LongFormatter.new(file_names) : ShortFormatter.new(file_names)
  end

  def file_names
    file_names =
      if @options.include?(:a)
        Dir.glob('*', File::FNM_DOTMATCH)
      else
        Dir.glob('*')
      end

    @options.include?(:r) ? file_names.reverse : file_names
  end
end
