# frozen_string_literal: true

require "pry"
require_relative "board_helper"
require_relative "color"

# Prepare the display
class Display
  include BoardHelper

  attr_reader :gameboard, :display_board, :fen, :start_square_name, :target_squares

  def initialize(position = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR", speical_squares = ["e2", ["e3", "e4"]])
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
    display_board.map do |square|
      if target_squares.include?(square.name) && square.piece == "-"
        square.piece = "\u23fa"
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

  # rubocop: todo Metrics/MethodLength, Metrics/AbcSize
  def color_squares
    # binding.pry
    @display_board = display_board.map do |square|
      row = square.coordinates.first
      column = square.coordinates.last
      if square.name == start_square_name
        hightlight_start_square(square)
      elsif (row.even? && column.even?) || (row.odd? && column.odd?) # light squares
        light_squares(square)
      else # dark squares
        dark_squares(square)
      end
    end
  end
  # rubocop: enable Metrics/MethodLength, Metrics/AbcSize

  def hightlight_square?(square)
    square.name == start_square_name || target_squares.include?(square.name)
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

if $PROGRAM_NAME == __FILE__
  board = Display.new
  puts board.build_display
end
