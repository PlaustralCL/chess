# frozen_string_literal: true

require_relative "piece_move"
require_relative "../check"

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

  # Only looks for pieces guarding/attacking the finish_square
  def clear_path?
    king_color = start_square.piece_color
    # If the finish square would not be check then the path is clear
    remove_king
    !Check.new(king_color, board_to_fen, finish_square.name).check?
  end

  def remove_king
    start_square.piece = "-"
    start_square.piece_color = nil
  end
end
