# frozen_string_literal: true

# Methods for determing the path between two squares on a achess board
module Path
  def find_path
    paths = [find_diagonal, find_antidiagonal, find_rank, find_file]
    target_row = paths.select { |row| row.length >= 1 }.flatten
    target_row = target_row.reverse if negative_movement?(target_row)
    final_path(target_row).to_a
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

  def select_row(board)
    board.select do |row|
      [start_square, finish_square].all? { |square| row.include?(square) }
    end.flatten
  end

  def final_path(target_row)
    target_row[target_index(target_row, start_square) + 1..target_index(target_row, finish_square) - 1].map
  end

  def target_index(array, target)
    array.index(target)
  end

  def negative_movement?(row)
    row.index(finish_square) < row.index(start_square)
  end
end