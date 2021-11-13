# frozen_string_literal: true

require_relative "piece_move"

# Validates that a requested pawn move is allowed
class WhitePawnMove < PieceMove
  def basic_rules?
    basic_move? || capture_allowed?
  end

<<<<<<< HEAD
  # Only applies to straight moves, not captures
  def clear_path?
    return true unless same_column?

    paths = [find_file]
    target_row = paths.select { |row| row.length >= 1 }.flatten
    target_row = target_row.reverse if negative_movement?(target_row)
    pieces_present?(target_row)
=======
  def clear_path?

>>>>>>> 4cd8e4f0de4a6ceaff65b1ff9ce98685be5811df
  end

  private

  def basic_move?
<<<<<<< HEAD
    allowed_distance? && same_column?
  end

  def allowed_distance?
    starting_row = 6
    first_move_distance = [1, 2]
    normal_distance = [1]
    distance = row(start_square) == starting_row ? first_move_distance : normal_distance
    distance.include?(row(start_square) - row(finish_square))
  end

  def capture_allowed?
    offset_one_row? && offset_one_column? && finish_square.piece_color == "black"
  end

  def offset_one_row?
    row(start_square) - row(finish_square) == 1
  end

  def offset_one_column?
    (column(start_square) - column(finish_square)).abs == 1
  end

  def find_file
    board = gameboard.each_slice(8).to_a.transpose
    select_row(board)
  end

  def select_row(board)
    board.select do |row|
      [start_square, finish_square].all? { |square| row.include?(square) }
    end.flatten
  end

  def pieces_present?(target_row)
    target_row[target_row.index(start_square) + 1..target_row.index(finish_square)].map(&:piece).all?("-")
  end

  def negative_movement?(row)
    row.index(finish_square) < row.index(start_square)
=======
    distance = square_row(start_square) == 6 ? [1, 2] : [1]
    distance.include?(square_row(start_square) - square_row(finish_square)) &&
      square_column(start_square) == square_column(finish_square)
  end

  def capture_allowed?
    square_row(start_square) - square_row(finish_square) == 1 &&
      (square_column(start_square) - square_column(finish_square)).abs == 1 &&
      finish_square.piece_color == "black"
>>>>>>> 4cd8e4f0de4a6ceaff65b1ff9ce98685be5811df
  end
end
