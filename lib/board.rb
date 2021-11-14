# frozen_string_literal: true

require_relative "board_helper"
require_relative "moves"

# Holds the frameword of the board in a 64 element board. The board can be
# sliced into an 8 x 8 matrix when needed. Each element of the array will be
# a Struct that maintains information about each square.
class Board
  include BoardHelper
  include Moves

  attr_reader :position, :gameboard

  def initialize(position = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR")
    @gameboard = Array.new(64) { Square.new }
    setup_board(position)
  end

  def check?(color, finish_name = find_king(color))
    enemy_pieces = find_enemies(color)
    enemy_pieces.any? do |square|
      move_object = piece_to_move_object(square.piece)
      move_object.valid_move?(square.name, finish_name)
    end
  end

  def piece_to_move_object(piece_name)
    piece_name = piece_name.downcase == "p" ? piece_name : piece_name.downcase
    move_options = {
      "b" => BishopMove,
      "p" => BlackPawnMove,
      "k" => KingMove,
      "n" => KnightMove,
      "q" => QueenMove,
      "r" => RookMove,
      "P" => WhitePawnMove
    }
    mover = move_options[piece_name]
    mover.new(board_to_fen)
  end

  def find_king(color)
    king_square = gameboard.select { |square| square.piece.downcase == "k" && square.piece_color == color }
    king_square.first.name
  end

  def find_enemies(color)
    enemy_color = color == "white" ? "black" : "white"
    gameboard.select { |square| square.piece_color == enemy_color }
  end
end
