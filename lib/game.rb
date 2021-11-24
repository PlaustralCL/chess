# frozen_string_literal: true

require_relative "board"
require_relative "player"
require_relative "display"
require_relative "check"

# Controls the flow of the game by coordinating among the various pieces
# that make up the chess game.
class Game
  attr_reader :board, :player1, :player2, :current_player

  def initialize(
    board = Board.new,
    player1 = Player.new("Player 1", "white"),
    player2 = Player.new("Player 2", "black")
  )

    @board = board
    @player1 = player1
    @player2 = player2
  end

  def play_game
    puts Display.new(board.board_to_fen).build_display
    @current_player = player1
    until game_over?
      play_one_round
      @current_player = current_player == player1 ? player2 : player1
    end
  end

  def game_over?
    checkmate? || stalemate?
  end

  # rubocop:todo Metrics/AbcSize
  def play_one_round
    start_square_name = current_player.input_start_square(board.start_square_choices(current_player.color))
    finish_square_name = current_player.input_finish_square(board.finish_square_choices(start_square_name))
    board.move_piece(start_square_name, finish_square_name) if board.valid_move?(start_square_name, finish_square_name)
    puts Display.new(board.board_to_fen).build_display
  end

  def checkmate?
    position = board.board_to_fen
    Check.new(current_player.color, position).checkmate?
  end

  def stalemate?
    position = board.board_to_fen
    Board.new(position).start_square_choices(current_player.color).empty? &&
      !Check.new(current_player.color, position).check?
  end
end
