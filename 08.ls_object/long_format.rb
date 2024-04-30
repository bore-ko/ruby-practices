# frozen_string_literal: true

require_relative 'ls_command'
require_relative 'file_detail'

class LongFormat
  attr_reader :file_details

  def initialize(file_names)
    @file_details = file_names.map { |name| FileDetail.new(name) }
  end

  def total_blocks
    @file_details.map(&:block).sum
  end

  def max_size_string_length
    @file_details.map { |file| file.size.to_s.length }.max
  end

  def max_size_string_length_for_nlinks
    @file_details.map { |file| file.nlink.to_s.length }.max
  end
end
