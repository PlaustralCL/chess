# frozen_string_literal: true

require_relative "piece_move"
require_relative "../check"

# Validates that a requested rook move is allowed
class KnightMove < PieceMove
  def basic_rules?
    knight_moves = [[1, -2], [2, -1], [2, 1], [1, 2], [-1, 2], [-2, 1], [-2, -1], [-1, -2]]
    relative_position = [
      row(start_square) - row(finish_square),
      column(start_square) - column(finish_square)
    ]
    knight_moves.include?(relative_position)
  end

  # A knight's path is always clear
  def clear_path?
    true
  end
end
