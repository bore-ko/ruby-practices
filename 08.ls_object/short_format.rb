# frozen_string_literal: true

require_relative 'ls_command'

class ShortFormat
  attr_reader :current_items

  STANDARD_SIZE = 25
  SMALL_SPACE_SIZE = 2
  BID_SPACE_SIZE = 8
  DIVISOR_NUMBER = 3.0

  def initialize(current_items)
    @items = current_items
    @size = max_items_size
    build_items
  end

  def max_items_size
    @items.map(&:size).max
  end

  def build_items
    added_spaces_filenames = items_with_spaces
    splited_filenames = divid_items(added_spaces_filenames)
    group_items(splited_filenames)
  end

  def items_with_spaces
    @items.map do |name|
      if @size >= STANDARD_SIZE
        name.ljust(@size + SMALL_SPACE_SIZE)
      else
        name.ljust(@size + BID_SPACE_SIZE)
      end
    end
  end

  def divid_items(added_spaces_filenames)
    turn_number = (added_spaces_filenames.size / DIVISOR_NUMBER).ceil
    filenames = []
    added_spaces_filenames.each_slice(turn_number) { |names| filenames.push(names) }
    filenames
  end

  def group_items(split_filenames)
    max_size = split_filenames.map(&:size).max
    split_filenames.map do |names|
      names.size < max_size && (max_size - names.size).times { names.push('') }
    end
    split_filenames.transpose
  end
end
