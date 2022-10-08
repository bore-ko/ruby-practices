require 'optparse/date'

def return_the_date
  now = Date.today
  today =
    { year: now.year,
      month: now.month }
  argv = ARGV.getopts('y:', 'm:')
  unless argv['y'].to_i.zero?
    today[:year] = argv['y'].to_i
  end
  unless argv['m'].to_i.zero?
    today[:month] = argv['m'].to_i
  end
  today
end

def first_day(today)
  Date.new(today[:year], today[:month], 1)
end

def last_day(today)
  Date.new(today[:year], today[:month], -1)
end

def week(date)
  one_week = date.strftime('%e').to_s + " "
  if date.wday == 6
    puts one_week
  else
    print one_week
  end
end

def main
  today = return_the_date
  print "#{today[:month]}月 #{today[:year]}".center(20)
  puts
  print %w(日 月 火 水 木 金 土).join(" ")
  puts
  print "   " * first_day(today).wday
  (first_day(today)..last_day(today)).each do |date|
    week(date)
  end
end

main
