# frozen_string_literal: true

require_relative "piece_move"
require_relative "diagonal"

# Validates that a requested rook move is allowed
class BishopMove < PieceMove
  include Diagonal

  # Update based on Observable from Board class
  def update(gameboard)
    @gameboard = gameboard
  end

  def basic_rules?
    find_diagonal.length >= 1 || find_antidiagonal.length >= 1
  end

  def find_diagonal
    board = diagonals(gameboard.each_slice(8).to_a)
    select_row(board)
  end

  def find_antidiagonal
    board = anti_diagonals(gameboard.each_slice(8).to_a)
    select_row(board)
  end

  def clear_path?
    # board = gameboard.each_slice(8).to_a
    # board = board.transpose unless same_row?
    # target_row = select_row(board)
    # target_row = target_row.reverse if negative_movement?(target_row)
    # pieces_present?(target_row)
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
