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

def first_day(year_month)
  Date.new(year_month.year, year_month.month, 1)
end

def last_day(year_month)
  Date.new(year_month.year, year_month.month, -1)
end

def main
  year_month = today
  print "#{year_month.month}月 #{year_month.year}".center(20)
  puts
  print %w(日 月 火 水 木 金 土).join(' ')
  puts
  print '   ' * first_day(year_month).wday
  (first_day(year_month)..last_day(year_month)).each do |day|
    day_string = day.day.to_s
    day_string = "\e[30m\e[47m#{day_string}\e[0m" if day == today && year_month.month == Date.today.month && year_month.year == Date.today.year
    day_string.prepend(' ') if day_string == '1' || day_string == '2' || day_string == '3' || day_string == '4' || day_string == '5' || day_string == '6' || day_string == '7' || day_string == '8' || day_string == '9'
    day_string += ' '
    day_string += "\n" if day.wday == 6
    print day_string
  end
end
main
