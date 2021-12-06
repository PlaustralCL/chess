# frozen_string_literal: true

# Updates the board for en passant captures
module BoardUpdatePawn
  # rubocop:todo Metrics/AbcSize
  def move_pawn
    # ep capture
    if finish_square.name == fen[:ep_target_square]
      fen_no_ep
      ep_capture
    # pawn jump enables ep for next move
    elsif (start_square.coordinates.first - finish_square.coordinates.first).abs == 2
      add_ep_to_fen
      basic_move
    # regular move - one square ahead or basic capture
    else
      fen_no_ep
      basic_move
    end
  end
  # rubocop:enable Metrics/AbcSize

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
end
