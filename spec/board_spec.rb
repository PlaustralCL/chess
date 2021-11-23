# frozen_string_literal: true

require_relative "../lib/board"

describe Board do
  subject(:new_board) { described_class.new }

  describe "#start_square_choices" do
    it "returns the names squares with pieces" do
      pieces_board = described_class.new("5rk1/5p2/8/8/8/6P1/5P2/5RK1")
      actual_piece_locations = pieces_board.start_square_choices("white")
      expect(actual_piece_locations).to contain_exactly("f1", "g1", "f2", "g3")
    end
  end

  describe "#finish_square_choices" do
    it "returns the names of squares the piece can move to" do
      bishop_start_board = described_class.new("2r3k1/8/4b3/8/2B3p1/8/8/6K1")
      actual_piece_locations = bishop_start_board.finish_square_choices("e6")
      expect(actual_piece_locations).to contain_exactly("c4", "d5", "f7")
    end
  end
end
