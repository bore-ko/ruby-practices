require 'optparse/date'

def get_year_month
  opt = OptionParser.new
  opt.on('-y') {|v| v }
  opt.on('-m') {|v| v }
  return argv = opt.parse!(ARGV) unless ARGV == []
  now = Date.today
  argv = now.year, now.month
end

def title
  get_year_month
  @year = get_year_month.first.to_i
  @month = get_year_month.last.to_i
  date = Date.new(@year, @month)
  print "#{date.mon}月 #{date.year}".center(20)
end

def day_of_week
  weeks = ['日', '月', '火', '水', '木', '金', '土']
  weeks.each do |week|
    print week + " "
  end
end

def blank_day
  @first_day = Date.new(@year, @month, 1)
  blank_days = @first_day.wday
  print "   " * blank_days
end

def date
  last_day = Date.new(@year, @month, -1)
  (@first_day..last_day).each do |date|
    one_week = date.strftime('%e').to_s + " "
    if date.wday == 6 
      puts one_week
    else
      print one_week
    end
  end
end

def calender
  title
  puts 
  day_of_week
  puts
  blank_day
  date
end

calender
