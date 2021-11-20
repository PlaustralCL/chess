# frozen_string_literal: true

require_relative "board_helper"
require_relative "check"

# Holds the frameword of the board in a 64 element board. The board can be
# sliced into an 8 x 8 matrix when needed. Each element of the array will be
# a Struct that maintains information about each square.
class Board
  include BoardHelper

  attr_reader :gameboard

  def initialize(position = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR")
    @gameboard = Array.new(64) { Square.new }
    setup_board(position)
  end

  def check?(color)
    Check.new(board_to_fen).check?(color)
  end

  def piece_locations(player_color)
    gameboard.select { |square| square.piece_color == player_color }
  end
end
