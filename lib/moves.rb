# frozen_string_literal: true

require_relative "moves/bishop_move"
require_relative "moves/black_pawn_move"
require_relative "moves/king_move"
require_relative "moves/knight_move"
require_relative "moves/piece_move"
require_relative "moves/queen_move"
require_relative "moves/rook_move"
require_relative "moves/white_pawn_move"
require_relative "moves/diagonal"
require_relative "moves/path"

# Hold all the piece related classes in one place.
module Moves
  include Diagonal
  include Path
end
