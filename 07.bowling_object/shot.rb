# frozen_string_literal: true

class Shot
  attr_reader :mark

  STRIKE = 'X'
  STRIKE_SCORE = 10

  def initialize(mark)
    @mark = mark
  end

  def score
    mark == STRIKE ? STRIKE_SCORE : mark.to_i
  end
end
