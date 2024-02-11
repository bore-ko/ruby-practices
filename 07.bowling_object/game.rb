# frozen_string_literal: true

require_relative 'frame'

class Game
  attr_reader :shots

  def initialize
    @shots = ARGV[0].split(',')
  end

  def frames
    frames = []
    frame = []
    shots.each do |s|
      frame << s

      next unless frames.size < 9

      if s == 'X'
        frames << [Shot.new(frame[0]).score]
        frame.clear
      elsif frame.size == 2
        frames << [Shot.new(frame[0]).score, Shot.new(frame[1]).score]
        frame.clear
      end
    end

    frames << if frame[2].nil?
                [Shot.new(frame[0]).score, Shot.new(frame[1]).score]
              else
                [Shot.new(frame[0]).score, Shot.new(frame[1]).score, Shot.new(frame[2]).score]
              end
  end

  def point
    add_point = 0
    9.times do |n|
      frame, next_frame, after_next_frame = frames.slice(n, 3)
      next_frame ||= []
      after_next_frame ||= []
      left_shots = next_frame + after_next_frame

      if frame[0] == 10
        add_point += Frame.new(left_shots[0], left_shots[1]).score
      elsif frame.sum == 10
        add_point += Frame.new(left_shots[0]).score
      end
    end
    add_point + frames.flatten.sum
  end
end

game = Game.new
puts game.point
