# frozen_string_literal: true

# Helper methods to set up the board: assign algebraic names, assign grid coordinates,
# and populate the initial position into the model.
module BoardHelper
  Square = Struct.new(:name, :coordinates, :piece, :piece_color)

  def name_converter(name)
    gameboard[gameboard.index { |square| square.name == name }]
  end

  def setup_board(position)
    assign_square_names
    assign_square_coordinates
    process_fen(position)
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

  def process_fen(full_fen)
    fen_keys = %i[piece_position side_to_move castling_ability ep_target_square halfmove_clock fullmove_clock]
    @fen = fen_keys.zip(full_fen.split).to_h
    fen_defaults
  end

  # rubocop:todo Metrics/AbcSize
  def fen_defaults
    @fen[:side_to_move] = "w" if fen[:side_to_move].nil?
    @fen[:castling_ability] = "-" if fen[:castling_ability].nil?
    @fen[:ep_target_square] = "-" if fen[:ep_target_square].nil?
    @fen[:halfmove_clock] = 0 if fen[:halfmove_clock].nil?
    @fen[:fullmove_clock] = 1 if fen[:fullmove_clock].nil?
  end
  # rubocop:enable Metrics/AbcSize

  def fen_to_array
    fen[:piece_position].gsub("/", "")
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

  def board_to_fen(board = gameboard)
    position = board.map(&:piece)
    position = position.each_slice(8).to_a.map(&:join).join("/")
    position = position.gsub(/-+/) { |dash| dash.length.to_s }
    @fen[:piece_position] = position
    fen_to_string
  end

  def fen_to_string
    [fen[:piece_position], fen[:side_to_move], fen[:castling_ability], fen[:ep_target_square], fen[:halfmove_clock], fen[:fullmove_clock]].join(" ")
  end
end
