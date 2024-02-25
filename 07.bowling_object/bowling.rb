# frozen_string_literal: true

require_relative 'game'

def main
  marks = ARGV[0].split(',')
  game = Game.new(marks)
  game.point
end

puts main
