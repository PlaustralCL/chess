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
      input = verify_input(request_input("Please enter the start square"), available_choices)
      return input if input

      puts "Input Error! Please choose a square with one of your pieces on it."
    end
  end

  def input_finish_square(available_choices)
    loop do
      input = verify_input(request_input("Please enter the finish square"), available_choices)
      return input if input

      puts "Input Error! That piece cannot move there."
    end
  end
end
