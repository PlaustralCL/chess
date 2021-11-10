# frozen_string_literal: true

# Helper methods to set up the board: assign algebraic names, assign grid coordinates,
# and populate the initial position into the model.
module BoardSetup
  Square = Struct.new(:name, :coordinates, :piece, :piece_color)

  def name_converter(name)
    gameboard[gameboard.index { |square| square.name == name }]
  end

  def setup_board
    assign_square_names
    assign_square_coordinates
    write_position(fen_to_array)
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

  def assign_square_coordinates
    create_square_coordinates.each_with_index do |coord, index|
      gameboard[index].coordinates = coord
    end
  end

  def create_square_coordinates
    row_numbers = (0..7).to_a
    col_numbers = (0..7).to_a
    row_numbers.product(col_numbers)
  end

  def fen_to_array
    position.gsub("/", "")
            .gsub(/\d/) { |num| ("-" * num.to_i) }
            .chars
  end

  def write_position(position)
    gameboard.each_with_index do |square, index|
      square.piece = position[index]
      square.piece_color = piece_color(position[index])
    end
  end

  def piece_color(piece)
    if piece.ord.between?(65, 90)
      "white"
    elsif piece.ord.between?(97, 122)
      "black"
    end
  end
end
