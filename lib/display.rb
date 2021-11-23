# frozen_string_literal: true

require_relative "board_helper"
require_relative "color"

# Prepare the display
class Display
  include BoardHelper

  attr_reader :gameboard, :display_board

  def initialize(position = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR")
    @gameboard = Array.new(64) { Square.new }
    setup_board(position)
  end

  def update_gameboard(board)
    @gameboard = board
  end

  def build_display
    replace_dashes
    center_pieces
    color_squares
    join_row
    add_rank_numbers
    add_file_letters
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
      piece_name = square.piece
      if (row.even? && column.even?) || (row.odd? && column.odd?)
        piece_name.bold_cyan_backgrouond
      else
        piece_name.bold
      end
    end
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
