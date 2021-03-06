# frozen_string_literal: true

require_relative "board_helper"
require_relative "color"

# Prepare the display
# rubocop: todo Metrics/ClassLength
class Display
  include BoardHelper

  attr_reader :gameboard, :display_board, :fen, :start_square_name, :target_squares

  def initialize(position = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR", speical_squares = [])
    @start_square_name = speical_squares.shift
    @target_squares = speical_squares.flatten
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
    piece_converter = {
      "p" => "\u265f",
      "r" => "\u265c",
      "n" => "\u265e",
      "b" => "\u265d",
      "q" => "\u265b",
      "k" => "\u265a",
      "-" => " "
    }
    display_board.map do |square|
      if target_squares.include?(square.name) && square.piece == "-"
        square.piece = "\u25cf"
        square.piece_color = "pink"
      else
        square.piece = piece_converter[square.piece.downcase]
      end
    end
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
      if special_square?(square)
        special_colors(square)
      elsif light_square?(square)
        light_squares(square)
      else
        dark_squares(square)
      end
    end
  end

  def light_square?(square)
    row = square.coordinates.first
    column = square.coordinates.last
    (row.even? && column.even?) || (row.odd? && column.odd?) # light squares
  end

  def special_colors(square)
    if square.name == start_square_name
      hightlight_start_square(square)
    else
      highlight_occupieced_square(square)
    end
  end

  def special_square?(square)
    square.name == start_square_name ||
      (target_squares.include?(square.name) && square.piece_color != "pink")
  end

  def highlight_occupieced_square(square)
    square.piece_color == "white" ? square.piece.white_pink : square.piece.black_pink
  end

  def hightlight_start_square(square)
    square.piece_color == "white" ? square.piece.white_green : square.piece.black_green
  end

  def light_squares(square)
    case square.piece_color
    when "white"
      square.piece.white_brown
    when "pink"
      square.piece.pink_brown
    else
      square.piece.black_brown
    end
  end

  def dark_squares(square)
    case square.piece_color
    when "white"
      square.piece.white_teal
    when "pink"
      square.piece.pink_teal
    else
      square.piece.black_teal
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
# rubocop: enable Metrics/ClassLength

if $PROGRAM_NAME == __FILE__
  board = Display.new
  puts board.build_display
end
