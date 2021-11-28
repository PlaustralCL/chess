# frozen_string_literal: true

require_relative "../lib/board"

describe Board do
  subject(:new_board) { described_class.new }

  describe "#start_square_choices" do
    context "when not all pieces have moves" do
      it "returns the names squares with pieces that can move" do
        pieces_board = described_class.new("6k1/8/8/2b5/8/5pp1/5P2/2R3K1")
        actual_piece_locations = pieces_board.start_square_choices("white")
        expect(actual_piece_locations).to contain_exactly("c1", "g1")
      end
    end

    context "when stalemate" do
      it "retuns an empty array" do
        stalemate = described_class.new("7k/8/6Q1/8/8/8/8/7K")
        expect(stalemate.start_square_choices("black")).to be_empty
      end
    end

    context "when new board" do
      it "returns pawns and knights" do
        expect(new_board.start_square_choices("white")).to contain_exactly("a2", "b2", "c2", "d2", "e2", "f2", "g2", "h2", "b1", "g1")
      end
    end
  end

  describe "#finish_square_choices" do
    context "when the piece has limited moves" do
      it "returns the names of squares the piece can move to" do
        bishop_start_board = described_class.new("2r3k1/8/4b3/8/2B3p1/8/8/6K1")
        actual_piece_locations = bishop_start_board.finish_square_choices("e6")
        expect(actual_piece_locations).to contain_exactly("c4", "d5", "f7")
      end
    end
  end

  describe "#valid_move?" do
    context "when given an valid move" do
      it "returns true" do
        expect(new_board.valid_move?("g1", "f3")).to eq(true)
      end
    end

    context "when given an invalid move" do
      it "returns false" do
        expect(new_board.valid_move?("a1", "f3")).to eq(false)
      end
    end
  end
end
