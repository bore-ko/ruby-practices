# frozen_string_literal: true

require_relative 'shot'

class Frame
  attr_reader :first_shot, :second_shot, :third_shot

  def initialize(first_shot, second_shot = nil, third_shot = nil)
    @first_shot = first_shot
    @second_shot = second_shot
    @third_shot = third_shot
  end

  def score
    first_shot.score + second_shot.score + third_shot.score
  end

  def strike?
    first_shot.mark == 'X'
  end

  def spare?
    first_shot.mark + second_shot.mark == 10
  end
end
