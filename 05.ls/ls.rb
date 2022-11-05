#!/usr/bin/env ruby
# frozen_string_literal: true

def file_name
  current_directory = Dir.entries('.')
  file_names = []
  current_directory.each { |f| file_names.push(f) unless f.match?(/^['.']/) }
  file_names
end

def file_blank(names)
  names.map { |name| name.ljust(24) }
end

def file_divided(names_blank)
  into_names_blank = names_blank
  turn_number = (into_names_blank.size / 3.0).ceil
  file_divide = []
  into_names_blank.sort.each_slice(turn_number) { |f| file_divide.push(f) }
  file_divide
end

def main
  names = file_name
  names_blank = file_blank(names)
  names_divided = file_divided(names_blank)
  if names_divided[0] && names_divided[1] && names_divided[2]
    names_divided[0].zip(names_divided[1], names_divided[2]) { |f| puts f.join }
  else
    print names_divided.join
  end
end

main
