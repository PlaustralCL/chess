# frozen_string_literal: true

require_relative "board_helper"
require_relative "color"

# Prepare the display
class Display
  include BoardHelper

  attr_reader :gameboard, :display_board, :fen

  def initialize(position = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR")
    @gameboard = Array.new(64) { Square.new }
    setup_board(position)
  end

  def update_gameboard(board)
    @gameboard = board
  end

  def build_display
    convert_pieces
    center_pieces
    color_squares
    join_row
    add_rank_numbers
    add_file_letters
  end

  def convert_pieces
    @display_board = gameboard
    # Alternative piece symbols:
    # piece_converter = {
    #   "p" => "*",
    #   "r" => "#",
    #   "n" => "$",
    #   "b" => "&",
    #   "q" => "@",
    #   "k" => "+",
    #   "-" => " "
    # }
    piece_converter = {
      "p" => "\u265f",
      "r" => "\u265c",
      "n" => "\u265e",
      "b" => "\u265d",
      "q" => "\u265b",
      "k" => "\u265a",
      "-" => " "
    }
    display_board.map { |square| square.piece = piece_converter[square.piece.downcase] }
  end

  def replace_dashes
    @display_board = gameboard
    display_board.map { |square| square.piece = " " if square.piece == "-" }
  end

  def center_pieces
    display_board.each do |square|
      square.piece = square.piece.center(3)
    end
  end

  def color_squares
    @display_board = display_board.map do |square|
      row = square.coordinates.first
      column = square.coordinates.last
      if (row.even? && column.even?) || (row.odd? && column.odd?) # light squares
        light_squares(square)
      else # dark squares
        dark_squares(square)
      end
    end
  end

  def light_squares(square)
    square.piece_color == "white" ? square.piece.white_brown : square.piece.black_brown
  end

  def dark_squares(square)
    square.piece_color == "white" ? square.piece.white_teal : square.piece.black_teal
  end

  def join_row
    @display_board = display_board.flatten.each_slice(8).to_a.map(&:join)
  end

  def add_rank_numbers
    @display_board = display_board.map.with_index { |row, index| "#{8 - index}  #{row}\n" }.join
  end

  def add_file_letters
    "#{display_board}    a  b  c  d  e  f  g  h"
  end
end

if $PROGRAM_NAME == __FILE__
  board = Display.new
  puts board.build_display
end
