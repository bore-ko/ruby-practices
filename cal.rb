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

def first_day(today)
  Date.new(today.year, today.month, 1)
end

def last_day(today)
  Date.new(today.year, today.month, -1)
end

def main(today)
  print "#{today.month}月 #{today.year}".center(20)
  puts
  print %w(日 月 火 水 木 金 土).join(' ')
  puts
  print '   ' * first_day(today).wday
  (first_day(today)..last_day(today)).each do |date|
    day = date.strftime('%e').to_s + ' '
    day += "\n" if date.wday == 6
    if date == today && date.month == Date.today.month && date.year == Date.today.year
      day.delete!(' ')
      day = "\e[30m\e[47m\"#{day}\"\e[0m"
      day.gsub!("\"", '')
      day += ' '
    end
    print day
  end
end

main(today)
