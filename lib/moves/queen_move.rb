# frozen_string_literal: true

require_relative "piece_move"
require_relative "diagonal"
require_relative "path"

# Validates that a requested queen move is allowed
class QueenMove < PieceMove
  include Diagonal
  include Path

  def basic_rules?
    paths = [find_diagonal, find_antidiagonal, find_rank, find_file]
    paths.any? { |row| row.length >= 1 }
  end

  def clear_path?
    paths = [find_diagonal, find_antidiagonal, find_rank, find_file]
    target_row = paths.select { |row| row.length >= 1 }.flatten
    target_row = target_row.reverse if negative_movement?(target_row)
    final_path(target_row).map(&:piece).all?("-")
  end
end
