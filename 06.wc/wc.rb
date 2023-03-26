#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

TEXT_SIZE = 8

def run_wc
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
  standard_inputs = $stdin.to_a
  if options == {}
    print_stdin_stats(standard_inputs)
  else
    print_stdin_stats_with_options(options, standard_inputs)
  end
  puts
end

def print_stdin_stats(standard_inputs)
  argv = standard_inputs
  print count_lines(argv).to_s.rjust(TEXT_SIZE)
  print count_words(argv).to_s.rjust(TEXT_SIZE)
  print count_bytesize(argv).to_s.rjust(TEXT_SIZE)
end

def count_lines(argv)
  argv.instance_of?(Array) ? argv.size : File.readlines(argv).count
end

def count_words(argv)
  argv.instance_of?(Array) ? argv.join.split.count : File.read(argv).split.count
end

def count_bytesize(argv)
  argv.instance_of?(Array) ? argv.join.bytesize : File.read(argv).bytesize
end

def print_stdin_stats_with_options(options, standard_inputs)
  argv = standard_inputs
  options.include?(:l) && (print count_lines(argv).to_s.rjust(TEXT_SIZE))
  options.include?(:w) && (print count_words(argv).to_s.rjust(TEXT_SIZE))
  options.include?(:c) && (print count_bytesize(argv).to_s.rjust(TEXT_SIZE))
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
  if options == {}
    print count_lines(argv).to_s.rjust(TEXT_SIZE)
    print count_words(argv).to_s.rjust(TEXT_SIZE)
    print count_bytesize(argv).to_s.rjust(TEXT_SIZE)
  else
    print_file_stats_with_options(options, argv)
  end
  print " #{argv.instance_of?(Array) ? argv.join : argv}"
end

def print_file_stats_with_options(options, argv)
  options.include?(:l) && (print count_lines(argv).to_s.rjust(TEXT_SIZE))
  options.include?(:w) && (print count_words(argv).to_s.rjust(TEXT_SIZE))
  options.include?(:c) && (print count_bytesize(argv).to_s.rjust(TEXT_SIZE))
end

def print_sum_file_stats(options)
  if options == {}
    print sum_lines.to_s.rjust(TEXT_SIZE)
    print sum_words.to_s.rjust(TEXT_SIZE)
    print sum_bytesize.to_s.rjust(TEXT_SIZE)
  else
    options.include?(:l) && (print sum_lines.to_s.rjust(TEXT_SIZE))
    options.include?(:w) && (print sum_words.to_s.rjust(TEXT_SIZE))
    options.include?(:c) && (print sum_bytesize.to_s.rjust(TEXT_SIZE))
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

run_wc
