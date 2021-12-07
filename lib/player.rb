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

  def input_start_square(available_choices)
    loop do
      input = verify_input(request_input("#{name}, Please enter the start square"), available_choices)
      return input if input

      puts "Input Error! That square does not have a piece you can move."
    end
  end

  def input_finish_square(available_choices)
    loop do
      input = verify_input(request_input("Please enter the finish square"), available_choices)
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
