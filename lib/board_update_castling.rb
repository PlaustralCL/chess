# frozen_string_literal: true

# Update the board based on castling and updated the FEN to reflect changes
# to the castling conditions
module BoardUpdateCastling
  def move_king
    if castling?
      castle_king
    else
      basic_move
    end
    fen_no_ep
    update_king_castling
  end

  def castling?
    (start_square.coordinates.first == finish_square.coordinates.first) &&
      ((start_square.coordinates.last - finish_square.coordinates.last).abs == 2)
  end

  def castle_king
    if finish_square.coordinates.last == 6 # kingside castling
      kingside_castling
    else # queenside castling
      queenside_castling
    end
  end

  def kingside_castling
    if start_square.piece_color == "white"
      basic_move(find_square("h1"), find_square("f1"))
    else
      basic_move(find_square("h8"), find_square("f8"))
    end
    basic_move
  end

  def queenside_castling
    if start_square.piece_color == "white"
      basic_move(find_square("a1"), find_square("d1"))
    else
      basic_move(find_square("a8"), find_square("d8"))
    end
    basic_move
  end

  def update_king_castling
    fen_castling = fen[:castling_ability].chars
    fen[:castling_ability] =
      if fen[:side_to_move] == "w"
        (fen_castling - %w[K Q]).join
      else
        (fen_castling - %w[k q]).join
      end
    fen[:castling_ability] = "-" if fen[:castling_ability].empty?
  end

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def update_rook_castling(rook_square = start_square)
    fen_castling = fen[:castling_ability].chars
    fen[:castling_ability] =
      case rook_square.name
      when "h1"
        (fen_castling - ["K"]).join
      when "a1"
        (fen_castling - ["Q"]).join
      when "h8"
        (fen_castling - ["k"]).join
      when "a8"
        (fen_castling - ["q"]).join
      else
        fen[:castling_ability]
      end
    fen[:castling_ability] = "-" if fen[:castling_ability].empty?
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop: enable Metrics/MethodLength
end
