# frozen_string_literal: true

# Finds the diagonals in a matrix (2d array)
# This is based on the explanation here: https://stackoverflow.com/a/23069914
# The basic idea is to add a buffer to each row to shift the elements so that
# the elements originally on the diagonal now line up in columns. The values used
# as padding are then removed and you are left with only the actual values in diagonals.
# In this case, nil is used for the padding to make it easier to remove later with #compact.
# The resulting 2d array is transposed to list each diagonal as a sub array.
#   1 2 3     |X|X|1|2|3|     | | |1|2|3|
#   4 5 6  => |X|4|5|6|X|  => | |4|5|6| | => [[7], [4, 8], [1, 5, 9], [2, 6], [3]]
#   7 8 9     |7|8|9|X|X|     |7|8|9| | |
module Diagonal
  def diagonals(matrix)
    matrix = copy_matrix(matrix)
    new_width = new_dimensions(matrix)
    matrix = matrix.map.with_index do |row, index|
      pad_front(row, new_width - index)
      pad_back(row, new_width)
    end
    matrix.transpose.map(&:compact)
  end

  def anti_diagonals(matrix)
    matrix = copy_matrix(matrix)
    new_width = new_dimensions(matrix)
    matrix = matrix.map.with_index do |row, index|
      pad_back(row, new_width - index)
      pad_front(row, new_width)
    end
    matrix.transpose.map(&:compact)
  end

  def copy_matrix(matrix)
    matrix.map { |row| [].replace(row) }
  end

  def new_dimensions(matrix)
    padding = matrix.size - 1
    matrix[0].size + padding
  end

  def pad_front(array, padding)
    array.unshift(nil) while array.size < padding
    array
  end

  def pad_back(array, padding)
    array.push(nil) while array.size < padding
    array
  end
end
