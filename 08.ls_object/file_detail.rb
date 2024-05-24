# frozen_string_literal: true

require_relative 'long_formatter'

class FileDetail
  attr_reader :name

  FILE_TYPES = {
    'file' => '-',
    'directory' => 'd',
    'link' => 'l'
  }.freeze

  MODE_TYPES = {
    1 => '--x',
    2 => '-w-',
    3 => '-wx',
    4 => 'r--',
    5 => 'r-x',
    6 => 'rw-',
    7 => 'rwx'
  }.freeze

  THIRD_BEHIND = -3
  SECOND_BEHIND = -2
  FIRST_BEHIND = -1

  def initialize(name)
    @name = name
    @file_stat = File.lstat(name)
  end

  def block
    @file_stat.blocks
  end

  def size
    @file_stat.size
  end

  def nlink
    @file_stat.nlink
  end

  def type
    FILE_TYPES[@file_stat.ftype]
  end

  def mode
    @file_stat.mode.to_s(8)
  end

  def owner_user_name
    Etc.getpwuid(@file_stat.uid).name
  end

  def owner_group_name
    Etc.getgrgid(@file_stat.gid).name
  end

  def last_updated_month
    @file_stat.mtime.month
  end

  def last_updated_day
    @file_stat.mtime.day
  end

  def last_updated_hour
    @file_stat.mtime.hour
  end

  def last_updated_min
    @file_stat.mtime.min
  end

  def readlink
    File.readlink(name) if type == 'l'
  end

  def owner_permission
    owner_permission = mode.slice(THIRD_BEHIND).to_i
    MODE_TYPES[owner_permission]
  end

  def group_permission
    group_permission = mode.slice(SECOND_BEHIND).to_i
    MODE_TYPES[group_permission]
  end

  def other_user_permission
    other_user_permission = mode.slice(FIRST_BEHIND).to_i
    MODE_TYPES[other_user_permission]
  end
end
