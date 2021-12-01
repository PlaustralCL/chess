# frozen_string_literal: true

require_relative "piece_move"
require_relative "../check"

# Validates that a requested king move is allowed
class KingMove < PieceMove
  def basic_rules?
    basic_move? || castling?
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
    castling_rights?
  end

  def clear_path?
    true
  end

  # Overrides the inhierited method since the generic method seems to cause problems
  def safe_king?
    king_color = start_square.piece_color
    move_king
    !Check.new(king_color, board_to_fen, finish_square.name).check?
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

  def move_king
    finish_square.piece = start_square.piece
    finish_square.piece_color = start_square.piece_color
    start_square.piece = "-"
    start_square.piece_color = nil
  end
end
