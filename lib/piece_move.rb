# frozen_string_literal: true

require_relative "board_helper"
require_relative "move_helper"

# Parent class for checking the validity of piece moves
class PieceMove
  include BoardHelper
  include MoveHelper

  attr_reader :gameboard, :start_square, :finish_square

  def initialize(position = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR")
    @gameboard = Array.new(64) { Square.new }
    setup_board(position)
  end

  # Update based on Observable from Board class
  def update(gameboard)
    @gameboard = gameboard
  end

  def valid_move?(start_name, finish_name)
    @start_square = name_converter(start_name)
    @finish_square = name_converter(finish_name)
    rules = %i[different_squares? finish_square_allowed? basic_rules? clear_path?]
    rules.all? { |rule| send(rule) }
  end

  def different_squares?
    start_square != finish_square
  end

  def finish_square_allowed?
    start_square.piece_color != finish_square.piece_color
  end

  def square_row(square)
    square.coordinates.first
  end

  def square_column(square)
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
end
