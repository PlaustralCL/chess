# frozen_string_literal: true

require_relative "moves"

# Methods to determine if a king is in check
module Check
  include Moves

  def check?(color, finish_name = find_king(color))
    enemy_pieces = find_enemies(color)
    enemy_pieces.any? do |square|
      move_object = piece_to_move_object(square.piece)
      move_object.valid_move?(square.name, finish_name)
    end
  end

  def piece_to_move_object(piece_name)
    piece_name = piece_name.downcase == "p" ? piece_name : piece_name.downcase
    move_options = {
      "b" => BishopMove,
      "p" => BlackPawnMove,
      "k" => KingMove,
      "n" => KnightMove,
      "q" => QueenMove,
      "r" => RookMove,
      "P" => WhitePawnMove
    }
    mover = move_options[piece_name]
    mover.new(board_to_fen)
  end

  def find_king(color)
    king_square = gameboard.select { |square| square.piece.downcase == "k" && square.piece_color == color }
    king_square.first.name
  end

  def find_enemies(color)
    enemy_color = color == "white" ? "black" : "white"
    gameboard.select { |square| square.piece_color == enemy_color }
  end
end
