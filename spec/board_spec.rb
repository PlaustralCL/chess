# frozen_string_literal: true

require_relative "../lib/board"

describe Board do
  subject(:new_board) { described_class.new }

  describe "#player_pieces" do
    it "returns the names squares with pieces" do
      pieces_board = described_class.new("5rk1/5p2/8/8/8/6P1/5P2/5RK1")
      actual_piece_locations = pieces_board.piece_locations("white").map(&:name)
      expect(actual_piece_locations).to contain_exactly("f1", "g1", "f2", "g3")
    end
  end
end
