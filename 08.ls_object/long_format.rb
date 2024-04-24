# frozen_string_literal: true

require_relative 'ls_command'
require_relative 'file_detail'

class LongFormat
  attr_reader :current_items, :items, :block, :max_size, :max_size_for_nlink

  def initialize(current_items)
    @items = current_items
    @block = total_blocks
    @max_size = max_size_string_length
    @max_size_for_nlink = max_size_string_length_for_nlinks
  end

  def total_blocks
    @items.map { |name| FileDetail.new(name).file_stat.blocks }.sum
  end

  def max_size_string_length
    @items.map { |name| File.lstat(name).size.to_s.length }.max
  end

  def max_size_string_length_for_nlinks
    @items.map { |name| File.lstat(name).nlink.to_s.length }.max
  end
end
