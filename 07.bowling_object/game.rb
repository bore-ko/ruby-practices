# frozen_string_literal: true

require_relative 'frame'
class Game
  attr_reader :shots

  def initialize(shots)
    @shots = shots
  end

  def frames
    frames = []
    tmp_save_shots_for_frame = []

    shots.each do |shot|
      tmp_save_shots_for_frame << shot

      if frames.size < 9
        if shot == 10
          frames << tmp_save_shots_for_frame.dup
          tmp_save_shots_for_frame.clear
        elsif tmp_save_shots_for_frame.size == 2
          frames << tmp_save_shots_for_frame.dup
          tmp_save_shots_for_frame.clear
        end
      end
    end

    frames << tmp_save_shots_for_frame
  end

  def add_point
    add_point = 0

    9.times do |n|
      frame, next_frame, after_next_frame = frames.slice(n, 3)
      next_frame ||= []
      after_next_frame ||= []
      left_shots = next_frame + after_next_frame

      if frame[0] == 10
        add_point += left_shots.slice(0, 2).sum
      elsif frame.sum == 10
        add_point += left_shots.fetch(0)
      end
    end

    add_point
  end
end

argv = ARGV[0].split(',')
shots = argv.map { |mark| Shot.new(mark).score }
game = Game.new(shots)
point = game.frames.map { |frame| Frame.new(frame[0], frame[1], frame[2]).score }.sum
puts point + game.add_point
