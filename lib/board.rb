# frozen_string_literal: true

require_relative "board_helper"
require_relative "check"
require_relative "moves"
require_relative "board_update_castling"
require_relative "board_update_pawn"

# Holds the frameword of the board in a 64 element board. The board can be
# sliced into an 8 x 8 matrix when needed. Each element of the array will be
# a Struct that maintains information about each square.
# rubocop:todo Metrics ClassLength
class Board
  include BoardHelper
  include Moves
  include BoardUpdateCastling
  include BoardUpdatePawn

  attr_reader :gameboard, :winner, :fen, :start_square, :finish_square

  def initialize(position = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1")
    @winner = ""
    @gameboard = Array.new(64) { Square.new }
    setup_board(position)
  end

  def update_current_player(player_color)
    fen[:side_to_move] = player_color == "white" ? "w" : "b"
  end

  def current_player_color
    fen[:side_to_move] == "w" ? "white" : "black"
  end

  def start_square_choices
    if check?
      start_choices_when_in_check
    else
      possible_start_squares = ally_locations(current_player_color)
      possible_start_squares.select do |square_name|
        finish_square_choices(square_name).length >= 1
      end
    end
  end

  def start_choices_when_in_check
    choices = []
    current_state = Check.new(current_player_color, board_to_fen)
    choices << find_king.name if current_state.safe_square?
    choices << current_state.capturing_pieces
    choices << current_state.blocking_pieces
    choices.flatten.uniq
  end

  def find_king
    king_square = gameboard.select { |square| square.piece.downcase == "k" && square.piece_color == current_player_color }
    king_square.first
  end

  def finish_square_choices(start_square_name)
    choices = []
    if check?
      choices = finish_choices_when_in_check(start_square_name)
    else
      possible_finish_squares = gameboard.reject { |square| square.piece_color == current_player_color }
      choices = possible_finish_squares.select do |square|
        valid_move?(start_square_name, square.name)
      end
    end
    choices.map(&:name)
  end

  def finish_choices_when_in_check(start_square_name)
    choices = []
    current_state = Check.new(current_player_color, board_to_fen)
    choices << current_state.capture_checking_pieces(start_square_name)
    choices << current_state.block_the_check(start_square_name).first
    choices << current_state.find_safe_square.first if find_square(start_square_name).piece.downcase == "k"
    choices.compact
  end

  def move_piece(start_square_name, finish_square_name)
    @start_square = find_square(start_square_name)
    @finish_square = find_square(finish_square_name)
    case start_square.piece.downcase
    when "k"
      move_king
    when "r"
      update_rook_castling
      fen_no_ep
      basic_move
    when "p"
      move_pawn
    else
      fen_no_ep
      basic_move
    end
    update_rook_castling(finish_square) if %w[a1 h1 a8 h8].include?(finish_square.name)
    board_to_fen # updates fen[:piece_position]
  end

  def basic_move(start = start_square, finish = finish_square)
    finish.piece = start.piece
    finish.piece_color = start.piece_color
    start.piece = "-"
    start.piece_color = nil
  end

  def valid_move?(start_square_name, finish_square_name)
    piece_name = find_square(start_square_name).piece
    move_object = piece_to_move_object(piece_name)
    move_object.valid_move?(start_square_name, finish_square_name)
  end

  def check?
    Check.new(current_player_color, board_to_fen).check?
  end

  def game_over?
    checkmate
    stalemate
    insufficent_material
    %w[white black stalemate insufficient].include?(winner)
  end

  def checkmate
    opposite_color = { "white" => "black", "black" => "white" }
    @winner = opposite_color[current_player_color] if Check.new(current_player_color, board_to_fen).checkmate?
  end

  def stalemate
    return if Check.new(current_player_color, board_to_fen).check?

    @winner = "stalemate" if start_square_choices.empty? && !Check.new(current_player_color, board_to_fen).check?
  end

  def insufficent_material
    remaining_pieces = gameboard.reject { |square| square.piece == "-" }.map { |square| square.piece.downcase }.sort
    @winner = "insufficient" if only_kings?(remaining_pieces) || only_bishop_or_knight?(remaining_pieces)
  end

  def only_kings?(remaining_pieces)
    remaining_pieces.count == 2
  end

  def only_bishop_or_knight?(remaining_pieces)
    return false unless remaining_pieces.count == 3

    kkb = %w[k k b].sort
    kkn = %w[k k n].sort
    kkb == remaining_pieces || kkn == remaining_pieces
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
# rubocop:enable Metrics ClassLength
