# frozen_string_literal: true

require_relative 'shot'

class Frame
  attr_reader :first_shot, :second_shot, :third_shot

  GOOD_SCORE = 10

  def initialize(first_shot, second_shot = nil, third_shot = nil)
    @first_shot = first_shot
    @second_shot = second_shot
    @third_shot = third_shot
  end

  def strike?
    first_shot.score == GOOD_SCORE
  end

  def spare?
    Shot.new(first_shot.mark).score + Shot.new(second_shot.mark).score == GOOD_SCORE
  end

  def from_scores
    scores = [Shot.new(first_shot.mark).score]

    scores.push(Shot.new(second_shot.mark).score) unless second_shot.nil?
    scores.push(Shot.new(third_shot.mark).score) unless third_shot.nil?
    scores
  end
end
