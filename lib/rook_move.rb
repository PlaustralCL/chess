# frozen_string_literal: true

require_relative "board_helper"

# Validates that q requested rook move is allowed
class RookMove
  include BoardHelper

  attr_reader :position, :gameboard, :start_square, :finish_square

  def initialize(position = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR")
    @position = position
    @gameboard = Array.new(64) { Square.new }
    setup_board
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

  def basic_rules?
    same_row? || same_column?
  end

  def same_row?
    start_square.coordinates.first == finish_square.coordinates.first
  end

  def same_column?
    start_square.coordinates.last == finish_square.coordinates.last
  end

  def clear_path?
    board = gameboard.each_slice(8).to_a
    board = board.transpose unless same_row?
    target_row = select_row(board)
    target_row = target_row.reverse if negative_movement?(target_row)
    pieces_present?(target_row)
  end

  def select_row(board)
    board.select do |row|
      [start_square, finish_square].all? { |square| row.include?(square) }
    end.flatten
  end

  def pieces_present?(target_row)
    target_row[target_index(target_row, start_square) + 1..target_index(target_row, finish_square) - 1].map(&:piece).all?("-")
  end

  def target_index(array, target)
    array.index(target)
  end

  def negative_movement?(row)
    target_index(row, finish_square) < target_index(row, start_square)
  end

  def square_row(square)
    square.coordinates.first
  end

  def square_column(square)
    square.coordinates.last
  end

  def update_start_square(square_name)
    @start_square = name_converter(square_name)
  end

  def update_finish_square(square_name)
    @finish_square = name_converter(square_name)
  end

end