# frozen_string_literal: true


# Interactions with the human player
class RandomPlayer

  attr_reader :name, :color

  def initialize(name = "Random Computer", color = "black")
    @name = name
    @color = color
  end

  def input_start_square(available_choices)
    available_choices.sample
  end

  def input_finish_square(available_choices)
    available_choices.sample
  end

  def input_promotion_piece
    available_choices = %w[1 2 3 4]
    available_choices.sample
  end
end
