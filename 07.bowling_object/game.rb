# frozen_string_literal: true

require_relative 'frame'
class Game
  attr_reader :marks

  def initialize(marks)
    @marks = marks
  end

  def frames
    frames = []
    tmp_save_shots_for_frame = []

    shots = marks.map { |mark| Shot.new(mark) }
    shots.each do |shot|
      tmp_save_shots_for_frame << shot.score

      if frames.size < 9
        if Frame.new(shot.score).strike?
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

  def point
    add_point = 0

    game_frames = frames.map { |first, second, third| Frame.new(first, second, third) }
    game_frames.map.with_index do |frame, index|
      break add_point if index >= 9

      left_shots = left_shots(frames, index)
      if frame.strike?
        add_point += left_shots[0] + left_shots[1]
      elsif frame.spare?
        add_point += left_shots[0]
      end
    end

    point = frames.map { |frame| Frame.new(frame[0], frame[1], frame[2]).score }.sum
    point + add_point
  end

  def left_shots(frames, index)
    next_frame = frames[index + 1] || []
    after_next_frame = frames[index + 2] || []
    next_frame + after_next_frame
  end
end
