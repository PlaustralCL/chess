# frozen_string_literal: true

require_relative "piece_move"

# Validates that a requested king move is allowed
class KingMove < PieceMove
  def basic_rules?
    king_moves = [[-1, 0], [-1, 1], [0, 1], [1, 1], [1, 0], [1, -1], [0, -1], [-1, -1]]
    relative_position = [
      row(start_square) - row(finish_square),
      column(start_square) - column(finish_square)
    ]
    king_moves.include?(relative_position)
  end

  def clear_path?

  end
end
