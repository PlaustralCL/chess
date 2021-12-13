# frozen_string_literal: true

# Updates the board for en passant captures and pawn promotions
module BoardUpdatePawn
  def move_pawn
    # ep capture
    if finish_square.name == fen[:ep_target_square]
      fen_no_ep
      ep_capture
    # pawn jump enables ep for next move
    elsif pawn_jump?
      add_ep_to_fen
      basic_move
    # regular move - one square ahead or basic capture
    else
      fen_no_ep
      basic_move
    end
  end

  def pawn_jump?
    (start_square.coordinates.first - finish_square.coordinates.first).abs == 2
  end

  def add_ep_to_fen
    ep_target_name =
      if fen[:side_to_move] == "w"
        [finish_file, (finish_rank.to_i - 1)].join
      else
        [finish_file, (finish_rank.to_i + 1)].join
      end
    fen[:ep_target_square] = ep_target_name
  end

  def fen_no_ep
    fen[:ep_target_square] = "-"
  end

  def ep_capture
    actual_pawn_name =
      if fen[:side_to_move] == "w"
        [finish_file, (finish_rank.to_i - 1)].join
      else
        [finish_file, (finish_rank.to_i + 1)].join
      end
    actual_pawn_square = find_square(actual_pawn_name)
    actual_pawn_square.piece = "-"
    actual_pawn_square.piece_color = nil
    basic_move
  end

  def finish_file
    finish_square.name[0]
  end

  def finish_rank
    finish_square.name[1]
  end

  def promote_pawn(piece_symbol)
    piece_converter = {
      "1" => "q",
      "2" => "n",
      "3" => "r",
      "4" => "b"
    }
    finish_square.piece =
      if fen[:side_to_move] == "b"
        piece_converter[piece_symbol]
      else
        piece_converter[piece_symbol].upcase
      end
    board_to_fen
  end

  def pawn_promotion?
    finish_square.piece.downcase == "p" &&
      (finish_rank == "1" || finish_rank == "8")
  end
end
