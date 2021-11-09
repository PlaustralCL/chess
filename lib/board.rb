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

  def valid_move?(start_name, finish_name)
    start_square = name_converter(start_name)
    finish_square = name_converter(finish_name)
    rules = %i[different_squares? finish_square_allowed? basic_rules? clear_path?]
    rules.all? { |rule| self.send(rule, start_square, finish_square) }
  end

  def name_converter(name)
    gameboard[gameboard.index { |square| square.name == name }]
  end

  def different_squares?(start_square, finish_square)
    start_square != finish_square
  end

  def finish_square_allowed?(start_square, finish_square)
    start_square.piece_color != finish_square.piece_color
  end

  def basic_rules?(start_square, finish_square)
    case start_square.piece.downcase
    when "r"
      same_row?(start_square, finish_square) || same_column?(start_square, finish_square)
    else
      start_square.piece.downcase
    end
  end

  def same_row?(start_square, finish_square)
    start_square.coordinates.first == finish_square.coordinates.first
  end

  def same_column?(start_square, finish_square)
    start_square.coordinates.last == finish_square.coordinates.last
  end

  def clear_path?(start_square, finish_square)
    board = gameboard.each_slice(8).to_a
    board = board.transpose unless same_row?(start_square, finish_square)
    target_row = select_row(board, start_square, finish_square)
    target_row = target_row.reverse if negative_movement?(target_row, start_square, finish_square)
    pieces_present?(target_row, start_square, finish_square)
  end

  def select_row(board, start_square, finish_square)
    board.select do |row|
      [start_square, finish_square].all? { |square| row.include?(square) }
    end.flatten
  end

  def pieces_present?(target_row, start_square, finish_square)
    target_row[target_index(target_row, start_square) + 1..target_index(target_row, finish_square) - 1].map(&:piece).all?("-")
  end

  def target_index(array, target)
    array.index(target)
  end

  def negative_movement?(row, start_square, finish_square)
    target_index(row, finish_square) < target_index(row, start_square)
  end

  def square_row(square)
    square.coordinates.first
  end

  def square_column(square)
    square.coordinates.last
  end
end
