# frozen_string_literal: true

require_relative "piece_move"

# Validates that a requested rook move is allowed
class KnightMove < PieceMove

  def basic_rules?
    knight_moves = [[1, -2], [2, -1], [2, 1], [1, 2], [-1, 2], [-2, 1], [-2, -1], [-1, -2]]
    relative_position = [
      square_row(start_square) - square_row(finish_square),
      square_column(start_square) - square_column(finish_square)
    ]
    knight_moves.include?(relative_position)
  end

  def clear_path?

  end

  def select_row(board)
    board.select do |row|
      [start_square, finish_square].all? { |square| row.include?(square) }
    end.flatten
  end

  def pieces_present?(target_row)
    target_row[target_index(target_row, start_square) + 1..target_index(target_row, finish_square) - 1].map(&:piece).all?("-")
  end

  def target_index(array, target)
    array.index(target)
  end

  def negative_movement?(row)
    target_index(row, finish_square) < target_index(row, start_square)
  end
end
