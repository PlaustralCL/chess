# frozen_string_literal: true

require_relative "board_setup"

# Holds the frameword of the board in a 64 element board. The board can be
# sliced into an 8 x 8 matrix when needed. Each element of the array will be
# a Struct that maintains information about each square.
class Board
  include BoardSetup

  Square = Struct.new(:name, :coordinates, :piece, :piece_color)

  attr_reader :position, :gameboard

  def initialize(position = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR")
    @position = position
    @gameboard = Array.new(64) { Square.new }
    setup_board
  end

end
