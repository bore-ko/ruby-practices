# frozen_string_literal: true

require 'optparse/date'

def today
  date = Date.today
  argv = ARGV.getopts('y:', 'm:')
  unless argv['y'].to_i.zero?
    year = argv['y'].to_i
    date = Date.new(year, date.month)
  end
  unless argv['m'].to_i.zero?
    month = argv['m'].to_i
    date = Date.new(date.year, month)
  end
  date
end

def first_day(date)
  Date.new(date.year, date.month, 1)
end

def last_day(date)
  Date.new(date.year, date.month, -1)
end

def main
  date = today
  print "#{date.month}月 #{date.year}".center(20)
  puts
  print %w(日 月 火 水 木 金 土).join(' ')
  puts
  print '   ' * first_day(date).wday
  (first_day(date)..last_day(date)).each do |d|
    day = d.day.to_s
    day = "\e[30m\e[47m#{day}\e[0m" if d == today && date.month == Date.today.month && date.year == Date.today.year
    day = day.prepend(' ') if day == '1' || day == '2' || day == '3' || day == '4' || day == '5' || day == '6' || day == '7' || day == '8' || day == '9'
    day += ' '
    day += "\n" if d.wday == 6
    print  day
  end
end
main
