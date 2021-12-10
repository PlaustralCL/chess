# frozen_string_literal: true

require_relative "board"
require_relative "game"
require_relative "player"
require_relative "random_player"
require_relative "user_input"

# Does the initial set up for the game: choosing an opponent, color, and new
# or saved game
class Setup
  include UserInput

  attr_reader :board, :player1, :player2

  def initialize
    @board = Board.new
    @player1 = Player.new
    @player2 = RandomPlayer.new
  end

  def setup_game
    welcome
    load_game if select_type_of_game == "2"
    @player2 = Player.new("Player 2", "black") if select_opponent == "1"
    start_game
    reset_game if play_again?
    puts "Thanks for playing!"
  end

  def start_game
    game = Game.new(board, player1, player2)
    game.play_game
  end

  def clear_terminal
    system("clear")
  end

  def welcome
    clear_terminal
    puts "Welcome to the chess!"
    puts
  end

  def select_color
    available_choices = %w[White Black Random]
    prompt_message = "Which color do you want to play?"
    receive_menu_input(available_choices, prompt_message)
  end

  def select_opponent
    available_choices = %w[Human Computer]
    prompt_message = "Would you like to play another person or the computer"
    receive_menu_input(available_choices, prompt_message)
  end

  def select_type_of_game
    available_choices = %w[New Saved]
    prompt_message = "Would you like to play a new game or load a saved game?"
    receive_menu_input(available_choices, prompt_message)
  end

  def load_game
    puts "Loading..."
    @board = Board.new("r1bqk1nr/pppp1ppp/2n5/2b1p3/1PB1P3/5N2/P1PP1PPP/RNBQK2R b KQkq - 0 4")
  end

  def play_again?
    prompt_message = "Do you want to play again? y/N"
    request_input(prompt_message) == "y"
  end

  def reset_game
    @board = Board.new
    @player1 = Player.new
    @player2 = RandomPlayer.new
    setup_game
  end
end
