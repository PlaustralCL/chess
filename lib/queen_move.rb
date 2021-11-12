# frozen_string_literal: true

require_relative "piece_move"
require_relative "diagonal"

# Validates that a requested queen move is allowed
class QueenMove < PieceMove
  include Diagonal

  def basic_rules?
    # In chess, ranks are the horizonatal rows, the files are vertical columns
    paths = [find_diagonal, find_antidiagonal, find_rank, find_file]
    paths.any? { |row| row.length >= 1 }
  end

  def find_diagonal
    board = diagonals(gameboard.each_slice(8).to_a)
    select_row(board)
  end

  def find_antidiagonal
    board = anti_diagonals(gameboard.each_slice(8).to_a)
    select_row(board)
  end

  def find_rank
    board = gameboard.each_slice(8).to_a
    select_row(board)
  end

  def find_file
    board = gameboard.each_slice(8).to_a.transpose
    select_row(board)
  end

  def clear_path?
    paths = [find_diagonal, find_antidiagonal, find_rank, find_file]
    target_row = paths.select { |row| row.length >= 1 }.flatten
    target_row = target_row.reverse if negative_movement?(target_row)
    pieces_present?(target_row)
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
    # target_index(row, finish_square) < target_index(row, start_square)
    row.index(finish_square) < row.index(start_square)
  end


end
