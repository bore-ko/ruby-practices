#!/usr/bin/env ruby
# frozen_string_literal: true

def params?(argv)
  argv == ['-a']
end

def current_items(option)
  if option
    Dir.glob('*', File::FNM_DOTMATCH)
  else
    Dir.glob('*')
  end
end

def current_items_max_length(names)
  names.map(&:size).max
end

def current_items_with_spaces(names, size)
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

def divided_current_items(added_blank_files)
  divisor_number = 3.0
  turn_number = (added_blank_files.size / divisor_number).ceil
  filenames = []
  added_blank_files.sort.each_slice(turn_number) { |names| filenames.push(names) }
  filenames
end

def grouped_current_items(split_filenames)
  max_size = split_filenames.map(&:size).max
  split_filenames.map do |names|
    names.size < max_size && (max_size - names.size).times { names.push('') }
  end
  split_filenames.transpose
end

def main
  option = params?(ARGV)
  names = current_items(option)
  size = current_items_max_length(names)
  added_spaces_filenames = current_items_with_spaces(names, size)
  split_filenames = divided_current_items(added_spaces_filenames)
  processed_filenames = grouped_current_items(split_filenames)
  processed_filenames.each { |filenames| puts filenames.join }
end

main
