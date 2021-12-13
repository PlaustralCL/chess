# frozen_string_literal: true

require_relative "board"
require_relative "game"
require_relative "player"
require_relative "random_player"
require_relative "user_input"
require_relative "find_files"

# Does the initial set up for the game: choosing an opponent, color, and new
# or saved game
class Setup
  include UserInput
  include FindFiles

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
    select_color
    instructions
    start_game
    reset_game if play_again?
  end

  def instructions
    puts "Please note that entering your move is a two step proccess:"
    puts "First, enter the coordinates of the piece you want to move and press enter."
    puts "Second, enter the coordinates of the destination square."
    puts "Press any key to continue to the game"
    gets
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
    case receive_menu_input(available_choices, prompt_message)
    when "1"
      player1_white
    when "2"
      player1_black
    else
      random_colors
    end
  end

  def player1_white
    player1.update_color("white")
    player2.update_color("black")
  end

  def player1_black
    player1.update_color("black")
    player2.update_color("white")
  end

  def random_colors
    colors = %w[white black]
    player1_color = colors.sample
    player2_color = (colors - [player1_color]).first
    player1.update_color(player1_color)
    player2.update_color(player2_color)
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
    available_games = files("saved_games")
    if available_games.empty?
      puts "No saved games, starting a new game."
      puts "Press any key to continue..."
      gets
    else
      prompt_message = "Please select the game you would like to load"
      selection_index = receive_menu_input(available_games, prompt_message).to_i - 1
      load_file("saved_games/#{available_games[selection_index]}")
    end
  end

  def load_file(filename)
    game_state = load_yaml(filename)
    @board = Board.new(game_state)
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
