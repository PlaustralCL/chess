# frozen_string_literal: true

require_relative "piece_move"

# Validates that a requested king move is allowed
class KingMove < PieceMove
  def basic_rules?
    true
  end

  def clear_path?
    false
  end
end
