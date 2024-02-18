# frozen_string_literal: true

require_relative 'game'

def main
  shots = ARGV[0].split(',')
  game = Game.new(shots)
  game.point
end

puts main
