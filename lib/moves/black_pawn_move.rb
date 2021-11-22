# frozen_string_literal: true

require_relative "piece_move"
require_relative "../check"

# Validates that a requested pawn move is allowed
class BlackPawnMove < PieceMove
  def basic_rules?
    basic_move? || capture_allowed?
  end

  # Only applies to straight moves, not captures
  def clear_path?
    return true unless same_column?

    paths = [find_file]
    target_row = paths.select { |row| row.length >= 1 }.flatten
    target_row = target_row.reverse if negative_movement?(target_row)
    pieces_present?(target_row)
  end

  private

  def basic_move?
    allowed_distance? && same_column?
  end

  def allowed_distance?
    starting_row = 1
    first_move_distance = [1, 2]
    normal_distance = [1]
    distance = row(start_square) == starting_row ? first_move_distance : normal_distance
    distance.include?(row(finish_square) - row(start_square))
  end

  def capture_allowed?
    offset_one_row? && offset_one_column? && finish_square.piece_color == "white"
  end

  def offset_one_row?
    row(finish_square) - row(start_square) == 1
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
  end
end
