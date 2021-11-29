# frozen_string_literal: true

require "pry"
require_relative "board_helper"
require_relative "check"
require_relative "moves"

# Holds the frameword of the board in a 64 element board. The board can be
# sliced into an 8 x 8 matrix when needed. Each element of the array will be
# a Struct that maintains information about each square.
class Board
  include BoardHelper
  include Moves

  attr_reader :gameboard, :current_player_color, :winner

  def initialize(position = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR")
    @winner = ""
    @gameboard = Array.new(64) { Square.new }
    setup_board(position)
  end

  def update_current_player(player_color)
    @current_player_color = player_color
  end

  def start_square_choices
    possible_start_squares = ally_locations(current_player_color)
    possible_start_squares.select do |square_name|
      finish_square_choices(square_name).length >= 1
    end
  end

  def finish_square_choices(start_square_name)
    start_square = find_square(start_square_name)
    choices = gameboard.select do |square|
      move_object = piece_to_move_object(start_square.piece)
      move_object.valid_move?(start_square_name, square.name)
    end
    choices.map(&:name)
  end

  def move_piece(start_square_name, finish_square_name)
    start_square = find_square(start_square_name)
    finish_square = find_square(finish_square_name)
    finish_square.piece = start_square.piece
    finish_square.piece_color = start_square.piece_color
    start_square.piece = "-"
    start_square.piece_color = nil
  end

  def valid_move?(start_square_name, finish_square_name)
    piece_name = find_square(start_square_name).piece
    move_object = piece_to_move_object(piece_name)
    move_object.valid_move?(start_square_name, finish_square_name)
  end

  def game_over?
    checkmate
    stalemate
    %w[white black stalemate].include?(winner)
  end

  def checkmate
    opposite_color = { "white" => "black", "black" => "white" }
    @winner = opposite_color[current_player_color] if Check.new(current_player_color, board_to_fen).checkmate?
  end

  def stalemate
    @winner = "stalemate" if start_square_choices.empty? && !Check.new(current_player_color, board_to_fen).check?
  end

  private

  def ally_locations(player_color)
    gameboard.select { |square| square.piece_color == player_color }.map(&:name)
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

  def find_square(square_name)
    gameboard[gameboard.index { |square| square.name == square_name }]
  end
end
