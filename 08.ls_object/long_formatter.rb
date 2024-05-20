# frozen_string_literal: true

require_relative 'ls_command'
require_relative 'file_detail'

class LongFormatter
  TWO_WIDTH = 2

  def initialize(file_names)
    @file_details = file_names.map { |name| FileDetail.new(name) }
  end

  def print_repeat_file_detail
    @file_details.each.with_index(1) do |file, index|
      print [
        index == 1 ? "total #{total_block}\n" : nil,
        file.type,
        "#{file.owner_permission}#{file.group_permission}#{file.other_user_permission}  ",
        "#{file.nlink.to_s.rjust(max_size_string_length_for_nlinks)} ",
        "#{file.owner_user_name}  ",
        "#{file.owner_group_name}  ",
        "#{file.size.to_s.rjust(max_size_string_length)} ",
        "#{file.last_updated_month.to_s.rjust(TWO_WIDTH)} ",
        "#{file.last_updated_day.to_s.rjust(TWO_WIDTH)} ",
        "#{format('%02d', file.last_updated_hour)}:#{format('%02d', file.last_updated_min)} ",
        file.name,
        file.readlink ? " -> #{file.readlink}" : nil
      ].join
      puts
    end
  end

  private

  def total_block
    @file_details.map(&:block).sum
  end

  def max_size_string_length
    @file_details.map { |file| file.size.to_s.length }.max
  end

  def max_size_string_length_for_nlinks
    @file_details.map { |file| file.nlink.to_s.length }.max
  end
end
