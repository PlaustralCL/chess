# frozen_string_literal: true

require_relative "board"
require_relative "random_player"
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
    show_board
    find_starting_player
    update_player
    until game_over?
      play_one_round
      @current_player = current_player == player1 ? player2 : player1
      update_player
    end
    final_message
  end

  def find_starting_player
    starting_color = board.fen[:side_to_move] == "w" ? "white" : "black"
    @current_player = player1.color == starting_color ? player1 : player2
  end

  def game_over?
    board.game_over?
  end

  def play_one_round
    start_square_name = collect_start_square
    finish_square_name = collect_finish_square(start_square_name)
    update_board(start_square_name, finish_square_name)
    show_board
  end

  def collect_start_square
    current_player.input_start_square(board.start_square_choices)
  end

  def collect_finish_square(start_square_name)
    current_player.input_finish_square(board.finish_square_choices(start_square_name))
  end

  def update_board(start_square_name, finish_square_name)
    board.move_piece(start_square_name, finish_square_name) if board.valid_move?(start_square_name, finish_square_name)
    board.promote_pawn(current_player.input_promotion_piece) if board.pawn_promotion?
  end

  def update_player
    board.update_current_player(current_player.color)
  end

  def show_board
    system("clear")
    puts Display.new(board.board_to_fen).build_display
  end

  def final_message
    case board.winner
    when "white"
      puts "Checkmate! White won."
    when "black"
      puts "Checkmate! Black won."
    when "stalemate"
      puts "Stalemate! The game is a draw."
    when "insufficient"
      puts "Insufficient material. The game is a draw."
    end
  end

end
