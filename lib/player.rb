# frozen_string_literal: true

require_relative "user_input"

# Interactions with the human player
class Player
  include UserInput

  attr_reader :name, :color

  def initialize(name = "Player 1", color = "white")
    @name = name
    @color = color
  end

  def update_color(color)
    @color = color
  end

  def input_start_square(available_choices)
    loop do
      available_choices += %w[q s] unless available_choices.include?("q")
      input = verify_input(request_input("#{color.capitalize}'s turn! Please enter the coordinates of the piece you want to move"), available_choices)
      return input if input

      puts "Input Error! That square does not have a piece you can move."
    end
  end

  def input_finish_square(available_choices)
    loop do
      available_choices += %w[q s] unless available_choices.include?("q")
      input = verify_input(request_input("Please enter the coordinates of legal move"), available_choices)
      return input if input

      puts "Input Error! That piece cannot move there."
    end
  end

  def input_promotion_piece
    available_choices = %w[Queen Knight Rook Bishop]
    loop do
      input = menu_input("Pawn Promotion - Please choose the number corresponeding to your new piece:", available_choices)
      input = verify_input(input, %w[1 2 3 4])
      return input if input

      puts "Input Error! That was not one of the allowed choices."
    end
  end
end
