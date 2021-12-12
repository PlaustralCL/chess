# frozen_string_literal: true

require_relative "board"
require_relative "check"
require_relative "display"
require_relative "game_file"
require_relative "player"
require_relative "random_player"

# Controls the flow of the game by coordinating among the various pieces
# that make up the chess game.
# rubocop: disable Metrics/ClassLength
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
    preparation
    until game_over?
      announce_check if board.check?
      break if play_one_round == "quit"

      @current_player = current_player == player1 ? player2 : player1
      update_player
    end
    final_message
  end

  def preparation
    show_board
    find_starting_player
    update_player
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
    return "quit" if start_square_name == "q"

    finish_square_name = collect_finish_square(start_square_name)
    return "quit" if finish_square_name == "q"

    update_board(start_square_name, finish_square_name)
    show_board
  end

  def save_game
    game_state = board.board_to_fen
    game_file = GameFile.new(game_state)
    game_file.write

    puts "The game is saved as #{game_file.filename}\nType any key to continue..."
    gets.chomp
    show_board
  end

  def collect_start_square
    loop do
      input = current_player.input_start_square(board.start_square_choices)
      return input unless input == "s"

      save_game
    end
  end

  def collect_finish_square(start_square_name)
    show_board(start_square_name)
    loop do
      input = current_player.input_finish_square(board.finish_square_choices(start_square_name))
      return input unless input == "s"

      save_game
    end
  end

  def update_board(start_square_name, finish_square_name)
    board.move_piece(start_square_name, finish_square_name) if board.valid_move?(start_square_name, finish_square_name)
    board.promote_pawn(current_player.input_promotion_piece) if board.pawn_promotion?
  end

  def update_player
    board.update_current_player(current_player.color)
  end

  def announce_check
    puts "Check!"
  end

  def show_board(start_square_name = "zz")
    system("clear")
    puts "Chess".center(29)
    if board.start_square
      show_previous_move
    else
      puts "\n\n"
    end
    puts Display.new(board.board_to_fen, start_square_name).build_display
  end

  def show_previous_move
    puts "Previous move: #{board.start_square.name} - #{board.finish_square.name}"
    puts
  end

  # rubocop: disable Metrics/MethodLength
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
    else
      puts "#{current_player.color.capitalize} resigns. Game over."
    end
  end
  # rubocop: enable Metrics/MethodLength
end
