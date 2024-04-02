# frozen_string_literal: true

require_relative 'ls_command'
require_relative 'file_detail'

class LongFormat
  attr_reader :current_items

  def initialize(current_items)
    @items = current_items
    @blocks = total_blocks
    @add_spaces = current_items_details_with_spaces
    @add_nlink_spaces = current_items_nlink_with_spaces
    build_current_items_details
  end

  def total_blocks
    @items.map { |name| File.lstat(name).blocks }.sum
  end

  def current_items_details_with_spaces
    @items.map { |name| File.lstat(name).size.to_s.length }.max
  end

  def current_items_nlink_with_spaces
    @items.map { |name| File.lstat(name).nlink.to_s.length }.max
  end

  def build_current_items_details
    print "total #{@blocks}\n"
    @items.map do |name|
      print_repeat_current_items_details(FileDetail.new(name))
    end
  end

  def print_repeat_current_items_details(file)
    print file.type
    print "#{file.owner_permission}#{file.group_permission}#{file.other_user_permission}  "
    print "#{file.nlink.to_s.rjust(@add_nlink_spaces)} "
    print "#{file.uid}  "
    print "#{file.gid}  "
    print "#{file.size.to_s.rjust(@add_spaces)} "
    two_width = 2
    print "#{file.mtime_month.to_s.rjust(two_width)} "
    print "#{file.mtime_day.to_s.rjust(two_width)} "
    print "#{format('%02d', file.mtime_hour)}:#{format('%02d', file.mtime_min)} "
    print file.name
    print " -> #{file.readlink}" unless file.readlink.nil?
    puts
  end
end
