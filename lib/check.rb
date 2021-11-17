# frozen_string_literal: true

require_relative "moves"
require_relative "board_helper"

# Methods to determine if a king is in check
class Check
  include Moves
  include BoardHelper

  attr_reader :gameboard, :king_color, :finish_name

  # The variable king_color is for the color of the king that may be in check/ checkmate.
  # For a KingMove, it would be the color of the king moving. At the end of a player's
  # turn, it would be the other player's color to see if the most recent move
  # placed his opponet in check or checkmate.
  def initialize(king_color, position = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR", finish_name = nil)
    @gameboard = Array.new(64) { Square.new }
    setup_board(position)
    @king_color = king_color
    @finish_name = finish_name || find_king
  end

  def check?
    checking_pieces.length >= 1
  end

  def checkmate?
    check? && no_escape?
  end

  def no_escape?
    no_safe_square?
  end

  # Returns true if there are no safe squares for the king, false if the king
  # has an escape square
  def no_safe_square?
    start_name = find_king
    gameboard.none? { |square| KingMove.new(board_to_fen).valid_move?(start_name, square.name) }
  end

  def capture_checking_piece?
    ally_pieces = find_allies
    danger_pieces = checking_pieces
    ally_pieces.any? do |square|
      move_object = piece_to_move_object(square.piece)
      move_object.valid_move?(square.name, finish_name)
    end

  end

  def checking_pieces
    find_enemies.select do |square|
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

  def find_king
    king_square = gameboard.select { |square| square.piece.downcase == "k" && square.piece_color == king_color }
    king_square.first.name
  end

  def find_enemies
    enemy_color = king_color == "white" ? "black" : "white"
    gameboard.select { |square| square.piece_color == enemy_color }
  end

  def find_allies
    gameboard.select { |square| square.piece_color == king_color }
  end
end
