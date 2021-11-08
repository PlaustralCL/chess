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

  end

  def name_converter(name)
    gameboard[gameboard.index { |square| square.name == name }]
  end

  def different_squares?(start_name, finish_name)
    start_name != finish_name
  end

  def finish_square_allowed?(start_square, finish_square)
    start_square.piece_color != finish_square.piece_color
  end

  def basic_rules?(start_square, finish_square)
    case start_square.piece.downcase
    when "r"
      start_square.coordinates.first == finish_square.coordinates.first || start_square.coordinates.last == finish_square.coordinates.last
    else
      start_square.piece.downcase
    end

  end

  # rubocop:todo Metrics/AbcSize
  def clear_path?(start_square, finish_square)

    board = gameboard.each_slice(8).to_a
    board = board.transpose unless start_square.coordinates.first == finish_square.coordinates.first
    target_row = board.select { |row| [start_square, finish_square].all? { |square| row.include?(square) } }
    target_row = target_row.flatten
    target_row = target_row.reverse if target_row.index(finish_square) < target_row.index(start_square)
    target_row[target_row.index(start_square) + 1..target_row.index(finish_square) - 1].map(&:piece).all?("-")


  end

end
