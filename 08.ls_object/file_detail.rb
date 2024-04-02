# frozen_string_literal: true

require_relative 'long_format'

class FileDetail
  attr_reader :name, :type, :parmission, :nlink, :uid, :gid, :size, :mtime_month, :mtime_day, :mtime_hour, :mtime_min, :readlink

  FILE_TYPES = { 'file' => '-', 'directory' => 'd', 'link' => 'l' }.freeze
  MODE_TYPES = { 1 => '--x', 2 => '-w-', 3 => '-wx', 4 => 'r--', 5 => 'r-x', 6 => 'rw-', 7 => 'rwx' }.freeze
  THIRD_BEHIND = -3
  SECOND_BEHIND = -2
  FIRST_BEHIND = -1

  def initialize(name)
    @name = name
    file = File.lstat(name)
    @type = FILE_TYPES[file.ftype]
    @mode = file.mode.to_s(8)
    @nlink = file.nlink
    @uid = Etc.getpwuid(file.uid).name
    @gid = Etc.getgrgid(file.gid).name
    @size = file.size
    @mtime_month = file.mtime.month
    @mtime_day = file.mtime.day
    @mtime_hour = file.mtime.hour
    @mtime_min = file.mtime.min
    @readlink = File.readlink(name) if @type == 'l'
  end

  def owner_permission
    owner_permission = @mode.slice(THIRD_BEHIND).to_i
    MODE_TYPES[owner_permission]
  end

  def group_permission
    group_permission = @mode.slice(SECOND_BEHIND).to_i
    MODE_TYPES[group_permission]
  end

  def other_user_permission
    other_user_permission = @mode.slice(FIRST_BEHIND).to_i
    MODE_TYPES[other_user_permission]
  end
end
