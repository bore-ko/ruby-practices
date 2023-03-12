#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'

FILE_TYPES = { 'file' => '-', 'directory' => 'd', 'link' => 'l' }.freeze
MODE_TYPES = { 1 => '--x', 2 => '-w-', 3 => '-wx', 4 => 'r--', 5 => 'r-x', 6 => 'rw-', 7 => 'rwx' }.freeze

def option(argv)
  optionparser = OptionParser.new
  optionparser.on('-a', '-r', '-l')
  optionparser.parse(argv)
  argv
end

def current_items(options)
  if options.to_s.match?('a') && options.to_s.match?('r')
    Dir.glob('*', File::FNM_DOTMATCH).reverse
  elsif options.to_s.match?('a')
    Dir.glob('*', File::FNM_DOTMATCH)
  elsif options.to_s.match?('r')
    Dir.glob('*').reverse
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
  added_blank_files.each_slice(turn_number) { |names| filenames.push(names) }
  filenames
end

def grouped_current_items(split_filenames)
  max_size = split_filenames.map(&:size).max
  split_filenames.map do |names|
    names.size < max_size && (max_size - names.size).times { names.push('') }
  end
  split_filenames.transpose
end

def total_blocks_of(names)
  names.map { |name| File.lstat(name).blocks }.sum
end

def current_items_details_file(name)
  File.lstat(name)
end

def current_items_permission(file)
  file_mode = file.mode.to_s(8)
  third_behind = -3
  second_behind = -2
  first_behind = -1
  owner_permission = file_mode.slice(third_behind).to_i
  group_permission = file_mode.slice(second_behind).to_i
  other_user_permission = file_mode.slice(first_behind).to_i
  "#{MODE_TYPES[owner_permission]}#{MODE_TYPES[group_permission]}#{MODE_TYPES[other_user_permission]}  "
end

def current_items_details_with_spaces(names)
  names.map { |name| File.lstat(name).size.to_s.length }.max
end

def current_items_nlink_with_spaces(names)
  names.map { |name| File.lstat(name).nlink }.max
end

def current_items_nlink(added_nlink_spaces, file)
  if added_nlink_spaces < 10
    "#{file.nlink} "
  else
    "#{file.nlink.to_s.rjust(2)} "
  end
end

def print_repeat_current_items_details(name, added_spaces, added_nlink_spaces)
  file = current_items_details_file(name)
  print FILE_TYPES[file.ftype]
  print current_items_permission(file)
  print current_items_nlink(added_nlink_spaces, file)
  print "#{Etc.getpwuid(file.uid).name}  "
  print "#{Etc.getgrgid(file.gid).name}  "
  print "#{file.size.to_s.rjust(added_spaces)} "
  two_width = 2
  print "#{file.mtime.month.to_s.rjust(two_width)} "
  print "#{file.mtime.day.to_s.rjust(two_width)} "
  print "#{format('%02d', file.mtime.hour)}:#{format('%02d', file.mtime.min)} "
  print name
  print " -> #{File.readlink(name)}" if FILE_TYPES[file.ftype] == 'l'
  puts
end

def print_current_items_details(current_items)
  blocks = total_blocks_of(current_items)
  print "total #{blocks}\n"
  added_spaces = current_items_details_with_spaces(current_items)
  added_nlink_spaces = current_items_nlink_with_spaces(current_items)
  current_items.each do |current_item|
    print_repeat_current_items_details(current_item, added_spaces, added_nlink_spaces)
  end
end

def puts_current_items(names)
  size = current_items_max_length(names)
  added_spaces_filenames = current_items_with_spaces(names, size)
  split_filenames = divided_current_items(added_spaces_filenames)
  processed_filenames = grouped_current_items(split_filenames)
  processed_filenames.each { |filenames| puts filenames.join }
end

def main
  if option(ARGV).to_s.match?('l')
    print_current_items_details(current_items(option(ARGV)))
  else
    puts_current_items(current_items(option(ARGV)))
  end
end

main
