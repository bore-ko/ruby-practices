# frozen_string_literal: true

require_relative 'ls_command'

class ShortFormat
  STANDARD_SIZE = 25
  SMALL_SPACE_SIZE = 2
  BID_SPACE_SIZE = 8
  DIVISOR_NUMBER = 3.0

  def initialize(file_names)
    @file_names = file_names
    build_file_names
  end

  def build_file_names
    added_spaces_filenames = names_with_spaces
    splited_filenames = divide_names(added_spaces_filenames)
    group_names(splited_filenames)
  end

  def names_with_spaces
    @file_names.map do |name|
      if max_names_size >= STANDARD_SIZE
        name.ljust(max_names_size + SMALL_SPACE_SIZE)
      else
        name.ljust(max_names_size + BID_SPACE_SIZE)
      end
    end
  end

  def max_names_size
    @file_names.map(&:size).max
  end

  def divide_names(added_spaces_filenames)
    turn_number = (added_spaces_filenames.size / DIVISOR_NUMBER).ceil
    filenames = []
    added_spaces_filenames.each_slice(turn_number) { |names| filenames.push(names) }
    filenames
  end

  def group_names(splited_filenames)
    max_size = splited_filenames.map(&:size).max
    splited_filenames.map do |names|
      names.size < max_size && (max_size - names.size).times { names.push('') }
    end
    splited_filenames.transpose
  end
end
