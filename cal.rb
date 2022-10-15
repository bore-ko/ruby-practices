# frozen_string_literal: true

require 'optparse/date'

def calc_month
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

def first_day(month)
  Date.new(month.year, month.month, 1)
end

def last_day(month)
  Date.new(month.year, month.month, -1)
end

def main
  month = calc_month
  print "#{month.month}月 #{month.year}".center(20)
  puts
  print %w(日 月 火 水 木 金 土).join(' ')
  puts
  print '   ' * first_day(month).wday
  (first_day(month)..last_day(month)).each do |day|
    day_string = day.day.to_s
    day_string = "\e[30m\e[47m#{day_string}\e[0m" if day == calc_month && month.month == Date.today.month && month.year == Date.today.year
    day_string = day_string.rjust(2) + ' '
    day_string += "\n" if day.wday == 6
    print day_string
  end
end
main
