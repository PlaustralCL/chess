# frozen_string_literal: true

require_relative "piece_move"

# Validates that a requested pawn move is allowed
class WhitePawnMove < PieceMove
  def basic_rules?
    basic_move? || capture_allowed?
  end

  def clear_path?

  end

  private

  def basic_move?
    distance = square_row(start_square) == 6 ? [1, 2] : [1]
    distance.include?(square_row(start_square) - square_row(finish_square)) &&
      square_column(start_square) == square_column(finish_square)
  end

  def capture_allowed?
    square_row(start_square) - square_row(finish_square) == 1 &&
      (square_column(start_square) - square_column(finish_square)).abs == 1 &&
      finish_square.piece_color == "black"
  end
end
