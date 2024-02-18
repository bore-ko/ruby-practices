# frozen_string_literal: true

require_relative 'frame'
class Game
  attr_reader :shots

  def initialize(shots)
    @shots = shots
  end

  def frames
    frames = []
    next_flag = false
    shots.each.with_index do |shot, index|
      next next_flag = false if next_flag

      if frames.size < 9
        frame = Frame.new(Shot.new(shot))

        if frame.strike?
          frames << frame
        else
          frames << Frame.new(Shot.new(shot), Shot.new(shots[index + 1]))
          next_flag = true
        end
      else
        frames << Frame.new(Shot.new(shot), Shot.new(shots[index + 1]), Shot.new(shots[index + 2]))
      end
    end

  frames

  #   shots = marks.map { |mark| Shot.new(mark).score }
  #
  #   frames = []
  #   tmp_save_shots_for_frame = []
  #   shots.each do |shot|
  #     tmp_save_shots_for_frame << shot
  #     frame = Frame.new(Shot.new(shot))
  #
  #     if frames.size < 9
  #       if frame.first_shot.mark == 10
  #         frames << frame
  #         tmp_save_shots_for_frame.clear
  #       elsif tmp_save_shots_for_frame.size == 2
  #         frames << Frame.new(frame, Shot.new(tmp_save_shots_for_frame[1]))
  #         tmp_save_shots_for_frame.clear
  #       end
  #     end
  #   end
  #
  #   frames << Frame.new(Shot.new(tmp_save_shots_for_frame[0]), Shot.new(tmp_save_shots_for_frame[1]), Shot.new(tmp_save_shots_for_frame[2])) # [[6, 3], [9, 0], [0, 3], [8, 2], [7, 3], [10], [9, 1], [8, 0], [10], [10, 1, 8]]
  end

  def point
    add_point = 0
    game_frames = frames.map { |first, second, third| Frame.new(first, second, third) }
    game_frames.map.with_index do |frame, index|
      break add_point if index >= 9
      current_shots = frame.first_shot.first_shot.score, frame.first_shot.second_shot.score

      left_shots = left_shots(frames, index)
      if current_shots.first == 10
        add_point += left_shots[0] + left_shots[1]
      elsif current_shots.sum == 10
        add_point += left_shots[0]
      end
    end

    point = frames.map { |frame| Frame.new(frame[0], frame[1], frame[2]).score }.sum
    point + add_point
  end

  def left_shots(frames, index)
    next_frame = [frames[index + 1].first_shot.score, frames[index + 1].second_shot.score] || []
    after_next_frame =  [frames[index + 2].first_shot.score, frames[index + 2].second_shot.score] || []
    next_frame + after_next_frame
  end
end
