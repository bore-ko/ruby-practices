# frozen_string_literal: true

require_relative 'shot'

class Frame
  attr_reader :first_shot, :second_shot, :third_shot

  FULL_SCORE = 10

  def initialize(first_shot, second_shot = nil, third_shot = nil)
    @first_shot = first_shot
    @second_shot = second_shot
    @third_shot = third_shot
  end

  def strike?
    first_shot.score == FULL_SCORE
  end

  def spare?
    first_shot.score + second_shot.score == FULL_SCORE
  end

  def from_scores
    [first_shot.score, second_shot&.score, third_shot&.score].compact
  end
end
