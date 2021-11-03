# frozen_string_literal: true

# Holds the frameword of the board in a 64 element board. The board can be
# sliced into an 8 x 8 matrix when needed. Each element of the array will be
# a Struct that maintains information about each square.
class Board
  Square = Struct.new(:name, :grid_coordinates, :occupied)

  attr_reader :gameboard

  def initialize(gameboard = Array.new(64) { Square.new })
    @gameboard = gameboard
    assign_properties
  end

  def assign_properties
    assign_square_names
  end

  def assign_square_names
    create_square_names.each_with_index do |name, index|
      gameboard[index].name = name
    end
  end

  def create_square_names
    col_names = ("a".."h").to_a
    row_names = ("1".."8").to_a.reverse
    names = col_names.product(row_names)
    names.map { |col, row| col + row }
         .each_slice(8).to_a.transpose
         .flatten
  end

end
