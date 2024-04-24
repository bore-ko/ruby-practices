# frozen_string_literal: true

require 'optparse'
require 'etc'
require_relative 'short_format'
require_relative 'long_format'
require_relative 'file_detail'

class LsCommand
  attr_reader :argv

  TWO_WIDTH = 2

  def initialize(argv)
    optionparser = OptionParser.new
    @options = {}
    optionparser.on('-a') { |v| @options[:a] = v }
    optionparser.on('-r') { |v| @options[:r] = v }
    optionparser.on('-l') { |v| @options[:l] = v }
    optionparser.parse(argv)
  end

  def show
    @formats = create_formats

    if @options.include?(:l)
      @formats.items.each.with_index(1) do |name, index|
        print_repeat_file_detail(FileDetail.new(name), index)
      end
    else
      @formats.build_items.each { |file_names| puts file_names.join }
    end
  end

  def create_formats
    @options.include?(:l) ? LongFormat.new(current_items) : ShortFormat.new(current_items)
  end

  def current_items
    current_items =
      if @options.include?(:a)
        Dir.glob('*', File::FNM_DOTMATCH)
      else
        Dir.glob('*')
      end

    @options.include?(:r) ? current_items.reverse : current_items
  end

  def print_repeat_file_detail(file, index)
    print [
      index == 1 ? "total #{@formats.block}\n" : nil,
      file.type,
      "#{file.owner_permission}#{file.group_permission}#{file.other_user_permission}  ",
      "#{file.nlink.to_s.rjust(@formats.max_size_for_nlink)} ",
      "#{file.owner_user_name}  ",
      "#{file.owner_group_name}  ",
      "#{file.size.to_s.rjust(@formats.max_size)} ",
      "#{file.last_updated_month.to_s.rjust(TWO_WIDTH)} ",
      "#{file.last_updated_day.to_s.rjust(TWO_WIDTH)} ",
      "#{format('%02d', file.last_updated_hour)}:#{format('%02d', file.last_updated_min)} ",
      file.name,
      file.readlink ? " -> #{file.readlink}" : nil
    ].join
    puts
  end
end
