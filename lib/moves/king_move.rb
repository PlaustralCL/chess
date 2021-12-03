# frozen_string_literal: true

require "pry"
require_relative "piece_move"
require_relative "../check"
require_relative "path"

# Validates that a requested king move is allowed
class KingMove < PieceMove
  include Path

  def basic_rules?
    basic_move?
  end

  # A non-castling move
  def basic_move?
    king_moves = [[-1, 0], [-1, 1], [0, 1], [1, 1], [1, 0], [1, -1], [0, -1], [-1, -1]]
    relative_position = [
      row(start_square) - row(finish_square),
      column(start_square) - column(finish_square)
    ]
    king_moves.include?(relative_position)
  end

  def castling?
    return false unless row(start_square) == row(finish_square)
    return false unless (column(start_square) - column(finish_square)).abs == 2

    castling_rights? && castling_path_clear? && no_check_in_path?
  end

  def clear_path?
    true
  end

  # Overrides the inhierited method since the generic method seems to cause problems
  def safe_king?(final_square = finish_square)
    position = fen[:piece_position]
    # binding.pry
    move_king(final_square)
    safety = !Check.new(start_square.piece_color, board_to_fen, final_square.name).check?
    setup_board(position)
    safety
  end

  ########################################
  ### Not part of the public interface ###
  ########################################

  def castling_rights?
    case column(start_square) - column(finish_square)
    when -2 # kingside castling
      kingside_rights?
    when 2 # queenside castling
      queenside_rights?
    else
      false
    end
  end

  def kingside_rights?
    (fen[:side_to_move] == "w" && fen[:castling_ability].include?("K")) ||
      (fen[:side_to_move] == "b" && fen[:castling_ability].include?("k"))
  end

  def queenside_rights?
    (fen[:side_to_move] == "w" && fen[:castling_ability].include?("Q")) ||
      (fen[:side_to_move] == "b" && fen[:castling_ability].include?("q"))
  end

  def castling_path_clear?
    paths = [find_rank]
    target_row = paths.select { |row| row.length >= 1 }.flatten
    target_row = target_row.reverse if negative_movement?(target_row)
    final_path = find_path(target_row).to_a
    final_path.map(&:piece).all?("-")
  end

  def find_path(target_row)
    if column(start_square) - column(finish_square) == -2
      kingside_path(target_row)
    else
      queenside_path(target_row)
    end
  end

  def kingside_path(target_row)
    target_row[target_index(target_row, start_square) + 1..target_index(target_row, finish_square)].map
  end

  def queenside_path(target_row)
    target_row[target_index(target_row, start_square) + 1..target_index(target_row, finish_square) + 1].map
  end

  def safe_castling?
    !Check.new(start_square.piece_color, board_to_fen).check? &&
      safe_king?(middle_square) &&
      # binding.pry
      safe_king?(finish_square)
  end

  def middle_square
    paths = [find_rank]
    target_row = paths.select { |row| row.length >= 1 }.flatten
    target_row = target_row.reverse if negative_movement?(target_row)
    target_row[target_index(target_row, start_square) + 1]
  end

  def move_king(final_square = finish_square)
    final_square.piece = start_square.piece
    final_square.piece_color = start_square.piece_color
    start_square.piece = "-"
    start_square.piece_color = nil
  end
end
