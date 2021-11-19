# frozen_string_literal: true

require_relative "moves"
require_relative "board_helper"

# rubocop:todo Metrics/ClassLength
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
    @finish_name = finish_name || find_king.name
  end

  def check?
    checking_pieces.length >= 1
  end

  def checkmate?
    check? && no_escape?
  end

  def no_escape?
    return false if safe_square? || capture_checking_piece? || block_the_check?

    true
  end

  def safe_square?
    start_name = find_king.name
    gameboard.any? { |square| KingMove.new(board_to_fen).valid_move?(start_name, square.name) }
  end

  # Only one piece can be captured in a turn. If two or more pieces are giving check, the king
  # will need to move, which is looked at by another method. The king capturing
  # the checking piece is the king moving to a safe square.
  def capture_checking_piece?
    return false if checking_pieces.length > 1

    finish_name = checking_pieces.first.name
    find_allies.any? do |square|
      move_object = piece_to_move_object(square.piece)
      move_object.valid_move?(square.name, finish_name)
    end
  end

  # Only one piece can be captured in a turn. If two or more pieces are giving check, the king
  # will need to move, which is looked at by another method.
  def block_the_check?
    return false if checking_pieces.length > 1

    checking_path = find_path
    find_allies.any? do |ally_square|
      move_object = piece_to_move_object(ally_square.piece)
      checking_path.any? do |finish_square|
        move_object.valid_move?(ally_square.name, finish_square.name)
      end
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
    king_square.first
  end

  def find_enemies
    enemy_color = king_color == "white" ? "black" : "white"
    gameboard.select { |square| square.piece_color == enemy_color }
  end

  def find_allies
    gameboard.select { |square| square.piece_color == king_color }
  end

  ### Path related methods ###

  def find_path
    paths = [find_diagonal, find_antidiagonal, find_rank, find_file]
    target_row = paths.select { |row| row.length >= 1 }.flatten
    target_row = target_row.reverse if negative_movement?(target_row)
    final_path(target_row).to_a
  end

  def find_diagonal
    board = diagonals(gameboard.each_slice(8).to_a)
    select_row(board)
  end

  def find_antidiagonal
    board = anti_diagonals(gameboard.each_slice(8).to_a)
    select_row(board)
  end

  def find_rank
    board = gameboard.each_slice(8).to_a
    select_row(board)
  end

  def find_file
    board = gameboard.each_slice(8).to_a.transpose
    select_row(board)
  end

  # need start and finish squares
  def select_row(board, start_square = checking_pieces.first, finish_square = find_king)
    board.select do |row|
      [start_square, finish_square].all? { |square| row.include?(square) }
    end.flatten
  end

  # need start and finish squares
  def final_path(target_row, start_square = checking_pieces.first, finish_square = find_king)
    target_row[target_index(target_row, start_square) + 1..target_index(target_row, finish_square) - 1].map
  end

  def target_index(array, target)
    array.index(target)
  end

  # need start and finish squares
  def negative_movement?(row, start_square = checking_pieces.first, finish_square = find_king)
    row.index(finish_square) < row.index(start_square)
  end

end
