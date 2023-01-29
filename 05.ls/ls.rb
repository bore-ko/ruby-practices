#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'

def option(argv)
  optionparser = OptionParser.new
  optionparser.on('-a', '-r', '-l')
  optionparser.parse(argv)
  argv
end

def current_items(options)
  case options
  when ['-a']
    Dir.glob('*', File::FNM_DOTMATCH)
  when ['-r']
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

def current_items_total_blocks(names)
  total_blocks = 0
  names.each do |name|
    details_file = File.lstat(name)
    total_blocks += details_file.blocks
  end
  total_blocks
end

def file_types_hash
  { 'file' => '-', 'directory' => 'd', 'link' => 'l' }
end

def mode_types_hash
  { 1 => '--x', 2 => '-w-', 3 => '-wx', 4 => 'r--', 5 => 'r-x', 6 => 'rw-', 7 => 'rwx' }
end

def print_current_items_details(name, file_types, mode_types)
  details_file = File.lstat(name)
  type = details_file.ftype
  print file_types[type]
  octal_string = details_file.mode.to_s(8)
  owner_permission = octal_string.slice(-3).to_i
  group_permission = octal_string.slice(-2).to_i
  other_user_permissoin = octal_string.slice(-1).to_i
  print "#{mode_types[owner_permission]}#{mode_types[group_permission]}#{mode_types[other_user_permissoin]}  "
  print "#{details_file.nlink} "
  print "#{Etc.getpwuid(details_file.uid).name}  "
  print "#{Etc.getgrgid(details_file.gid).name}  "
  print "#{details_file.size.to_s.rjust(4)} "
  print "#{details_file.mtime.month.to_s.rjust(2)} "
  print "#{details_file.mtime.day.to_s.rjust(2)} "
  print "#{format('%02d', details_file.mtime.hour)}:#{format('%02d', details_file.mtime.min)} "
  print name
  print " -> #{File.readlink(name)}" if file_types[type] == 'l'
  puts
end

def main
  options = option(ARGV)
  names = current_items(options)
  if  options == ['-l']
    blocks = current_items_total_blocks(names)
    print "total #{blocks}"
    puts
    file_types = file_types_hash
    mode_types = mode_types_hash
    names.each do |name|
      print_current_items_details(name, file_types, mode_types)
    end
    exit
  end
  size = current_items_max_length(names)
  added_spaces_filenames = current_items_with_spaces(names, size)
  split_filenames = divided_current_items(added_spaces_filenames)
  processed_filenames = grouped_current_items(split_filenames)
  processed_filenames.each { |filenames| puts filenames.join }
end

main
