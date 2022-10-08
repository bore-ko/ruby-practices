#!/usr/bin/env ruby
# frozen_string_literal: true

score = ARGV[0]
scores = score.split(',')
shots = []
scores.each do |s|
  if s == 'X'
    shots << 10
    shots << 0
  else
    shots << s.to_i
  end
end

frames = []
shots.each_slice(2) do |s|
  frames << s
end

n = 0
9.times do
  if frames[n].first == 10 && frames[n + 1].first == 10
    frames[n] << frames[n + 1].flatten << frames[n + 2].first
  elsif frames[n].first == 10
    frames[n] << frames[n + 1].flatten
  elsif frames[n].first.zero? && frames[n].sum == 10
    frames[n] << frames [n + 1].first
  elsif frames[n].sum == 10
    frames[n] << frames[n + 1].first
  end
  n += 1
end

puts frames.flatten.sum
