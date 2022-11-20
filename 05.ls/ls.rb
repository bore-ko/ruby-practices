#!/usr/bin/env ruby
# frozen_string_literal: true

def file_or_directory_names
  Dir.glob('*')
end

def max_file_size(names)
  names.map(&:size).max
end

def filenames_with_spaces(names, size)
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

def divided_filnames(added_blank_files)
  divisor_number = 3.0
  turn_number = (added_blank_files.size / divisor_number).ceil
  filenames = []
  added_blank_files.sort.each_slice(turn_number) { |names| filenames.push(names) }
  filenames
end

def grouped_filenames(split_filenames)
  if split_filenames[0] && split_filenames[1] && split_filenames[2]
    split_filenames[0].zip(split_filenames[1], split_filenames[2])
  elsif split_filenames[1] && split_filenames[2].nil?
    split_filenames[2] = []
    split_filenames[2] << split_filenames[1].pop
    split_filenames[0].zip(split_filenames[1], split_filenames[2])
  end
end

def main
  names = file_or_directory_names
  size = max_file_size(names)
  added_spaces_filenames = filenames_with_spaces(names, size)
  split_filenames = divided_filnames(added_spaces_filenames)
  processed_filenames = grouped_filenames(split_filenames)
  if processed_filenames
    processed_filenames.each { |f| puts f.join }
  else
    print split_filenames.join
  end
end

main
