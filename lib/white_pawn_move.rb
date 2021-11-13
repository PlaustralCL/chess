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
    distance = row(start_square) == 6 ? [1, 2] : [1]
    distance.include?(row(start_square) - row(finish_square)) &&
      column(start_square) == column(finish_square)
  end

  def capture_allowed?
    row(start_square) - row(finish_square) == 1 &&
      (column(start_square) - column(finish_square)).abs == 1 &&
      finish_square.piece_color == "black"
  end
end
