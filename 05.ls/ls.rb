#!/usr/bin/env ruby
# frozen_string_literal: true

def current_item
  Dir.glob('*')
end

def max_length_current_item(names)
  names.map(&:size).max
end

def current_item_with_spaces(names, size)
  standard_size = 25
  small_space_size = 2
  big_space_size = 8
  names.map do |name|
    if size >= standard_size
      name.ljust(size + small_space_size)
    else
      name.ljust(size + big_space_size)
    end
  end
end

def divided_current_item(added_blank_files)
  divisor_number = 3.0
  turn_number = (added_blank_files.size / divisor_number).ceil
  filenames = []
  added_blank_files.sort.each_slice(turn_number) { |names| filenames.push(names) }
  filenames
end

def grouped_current_item(split_filenames)
  max_size = split_filenames.map(&:size).max
  split_filenames.map do |names|
    names.size < max_size && (max_size - names.size).times { names.push('') }
  end
  split_filenames.transpose
end

def main
  names = current_item
  size = max_length_current_item(names)
  added_spaces_filenames = current_item_with_spaces(names, size)
  split_filenames = divided_current_item(added_spaces_filenames)
  processed_filenames = grouped_current_item(split_filenames)
  processed_filenames.each { |filenames| puts filenames.join }
end

main
