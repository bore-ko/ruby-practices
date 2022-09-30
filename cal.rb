require 'optparse/date'

def get_year_month
  today = Date.today
  params = ARGV.getopts('y:', 'm:')
  if params['y'].to_i.zero?
    @year = today.year
  else 
    @year = params['y'].to_i
  end

  if params['m'].to_i.zero?
    @month = today.month
  else
    @month = params['m'].to_i
  end
  Date.new(@year, @month)
end

def blank_day
  @first_day = Date.new(@year, @month, 1)
  @first_day.wday
end

def last_day
  Date.new(@year, @month, -1)
end

def main(year_month)
  print "#{@month}月 #{@year}".center(20)
  puts
  print %w(日 月 火 水 木 金 土).join(" ")
  puts
  print "   " * blank_day
  (@first_day..last_day).each do |date|
    one_week = date.strftime('%e').to_s + " "
    if date.wday == 6
      puts one_week
    else
      print one_week
    end
  end
end

main(get_year_month)
