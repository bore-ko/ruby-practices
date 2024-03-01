# frozen_string_literal: true

require_relative 'frame'

class Game
  attr_reader :marks

  def initialize(marks)
    @marks = marks
  end

  def point
    point = 0
    frames.each.with_index do |frame, index|
      if index <= 8
        left_shots = left_shots(frames, index)

        if frame.strike?
          point += left_shots[0] + left_shots[1]
        elsif frame.spare?
          point += left_shots[0]
        end
      end

      point += frame.from_scores.sum if index <= 9
    end

    point
  end

  def left_shots(frames, index)
    next_frame = frames[index + 1].from_scores
    after_next_frame = frames[index + 2].from_scores

    next_frame + after_next_frame
  end

  private

  def frames
    shots = marks.map { |mark| Shot.new(mark) }

    frames = []
    next_flag = false
    shots.each.with_index do |shot, index|
      next next_flag = false if next_flag

      if frames.size < 9
        frame = Frame.new(shot)

        if frame.strike?
          frames << frame
        else
          frames << Frame.new(shot, shots[index + 1])
          next_flag = true
        end
      else
        frames << Frame.new(shot, shots[index + 1], shots[index + 2])
      end
    end

    frames
  end
end
