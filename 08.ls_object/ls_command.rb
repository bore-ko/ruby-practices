# frozen_string_literal: true

require 'optparse'
require 'etc'
require_relative 'short_format'
require_relative 'file_detail'

class LsCommand
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
    @formatter = create_formatter

    if @options.include?(:l)
      @formatter.map { |name| FileDetail.new(name) }.each.with_index(1) do |file, index|
        print_repeat_file_detail(file, index)
      end
    else
      @formatter.puts_file_names
    end
  end

  def create_formatter
    @options.include?(:l) ? file_names : ShortFormat.new(file_names)
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

  def print_repeat_file_detail(file, index)
    print [
      index == 1 ? "total #{FileDetail.total_blocks(@formatter)}\n" : nil,
      file.type,
      "#{file.owner_permission}#{file.group_permission}#{file.other_user_permission}  ",
      "#{file.nlink.to_s.rjust(FileDetail.max_size_string_length_for_nlinks(@formatter))} ",
      "#{file.owner_user_name}  ",
      "#{file.owner_group_name}  ",
      "#{file.size.to_s.rjust(FileDetail.max_size_string_length(@formatter))} ",
      "#{file.last_updated_month.to_s.rjust(TWO_WIDTH)} ",
      "#{file.last_updated_day.to_s.rjust(TWO_WIDTH)} ",
      "#{format('%02d', file.last_updated_hour)}:#{format('%02d', file.last_updated_min)} ",
      file.name,
      file.readlink ? " -> #{file.readlink}" : nil
    ].join
    puts
  end
end
