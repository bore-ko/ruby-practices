#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

TEXT_SIZE = 8

def run
  File.pipe?($stdin) ? wc_stdin((option(ARGV))) : wc_paths((option(ARGV)))
end

def option(argv)
  opt = OptionParser.new
  params = {}
  opt.on('-l') { |v| params[:l] = v }
  opt.on('-w') { |v| params[:w] = v }
  opt.on('-c') { |v| params[:c] = v }
  opt.parse!(argv)
  params
end

def wc_stdin(options)
  if options.empty?
    print_stdin_stats
  else
    print_stdin_stats_with_options(options)
  end
  puts
end

def print_stdin_stats
  argv = $stdin.to_a
  print count_lines(argv).to_s.rjust(TEXT_SIZE)
  print count_words(argv).to_s.rjust(TEXT_SIZE)
  print count_bytesize(argv).to_s.rjust(TEXT_SIZE)
end

def count_lines(argv)
  argv.instance_of?(Array) ? argv.count : File.readlines(argv).count
end

def count_words(argv)
  argv.instance_of?(Array) ? argv.join.split.count : File.read(argv).split.count
end

def count_bytesize(argv)
  argv.instance_of?(Array) ? argv.join.bytesize : File.read(argv).bytesize
end

def print_stdin_stats_with_options(options)
  argv = $stdin.to_a
  print count_lines(argv).to_s.rjust(TEXT_SIZE) if options[:l]
  print count_words(argv).to_s.rjust(TEXT_SIZE) if options[:w]
  print count_bytesize(argv).to_s.rjust(TEXT_SIZE) if options[:c]
end

def wc_paths(options)
  if ARGV.size >= 2
    ARGV.each do |argv|
      print_file_stats(options, argv)
      puts
    end
    print_sum_file_stats(options)
    print ' total'
  else
    print_file_stats(options, ARGV.join)
  end
  puts
end

def print_file_stats(options, argv)
  if options.empty?
    print count_lines(argv).to_s.rjust(TEXT_SIZE)
    print count_words(argv).to_s.rjust(TEXT_SIZE)
    print count_bytesize(argv).to_s.rjust(TEXT_SIZE)
  else
    print_file_stats_with_options(options, argv)
  end
  print " #{argv.instance_of?(Array) ? argv.join : argv}"
end

def print_file_stats_with_options(options, argv)
  print count_lines(argv).to_s.rjust(TEXT_SIZE) if options[:l]
  print count_words(argv).to_s.rjust(TEXT_SIZE) if options[:w]
  print count_bytesize(argv).to_s.rjust(TEXT_SIZE) if options[:c]
end

def print_sum_file_stats(options)
  if options.empty?
    print sum_lines.to_s.rjust(TEXT_SIZE)
    print sum_words.to_s.rjust(TEXT_SIZE)
    print sum_bytesize.to_s.rjust(TEXT_SIZE)
  else
    print sum_lines.to_s.rjust(TEXT_SIZE) if options[:l]
    print sum_words.to_s.rjust(TEXT_SIZE) if options[:w]
    print sum_bytesize.to_s.rjust(TEXT_SIZE) if options[:c]
  end
end

def sum_lines
  ARGV.map { |argv| count_lines(argv) }.sum
end

def sum_words
  ARGV.map { |argv| count_words(argv) }.sum
end

def sum_bytesize
  ARGV.map { |argv| count_bytesize(argv) }.sum
end

run
