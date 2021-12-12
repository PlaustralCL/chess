# frozen_string_literal: true

require_relative "../board_helper"

# Parent class for checking the validity of piece moves
class PieceMove
  include BoardHelper

  attr_reader :gameboard, :start_square, :finish_square, :fen

  def initialize(position = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR")
    @gameboard = Array.new(64) { Square.new }
    setup_board(position)
  end

  def update(gameboard)
    @gameboard = gameboard
  end

  def valid_move?(start_name, finish_name)
    @start_square = name_converter(start_name)
    @finish_square = name_converter(finish_name)
    rules = %i[different_squares? finish_square_allowed? basic_rules? clear_path? safe_king?]
    rules.all? { |rule| send(rule) }
  end

  def different_squares?
    start_square != finish_square
  end

  def finish_square_allowed?
    start_square.piece_color != finish_square.piece_color
  end

  def safe_king?
    king_color = start_square.piece_color
    move_piece unless finish_square.piece.downcase == "k"
    !Check.new(king_color, board_to_fen, find_king(king_color).name).check?
  end

  def row(square)
    square.coordinates.first
  end

  def column(square)
    square.coordinates.last
  end

  def same_row?
    start_square.coordinates.first == finish_square.coordinates.first
  end

  def same_column?
    start_square.coordinates.last == finish_square.coordinates.last
  end

  def update_start_square(square_name)
    @start_square = name_converter(square_name)
  end

  def update_finish_square(square_name)
    @finish_square = name_converter(square_name)
  end

  def basic_rules?
    raise "Called abstract method: basic_rules?"
  end

  def clear_path?
    raise "Called abstract method: clear_path?"
  end

  def move_piece
    finish_square.piece = start_square.piece
    finish_square.piece_color = start_square.piece_color
    start_square.piece = "-"
    start_square.piece_color = nil
    board_to_fen
  end

  def find_king(king_color)
    king_square = gameboard.select { |square| square.piece.downcase == "k" && square.piece_color == king_color }
    king_square.first
  end
end
