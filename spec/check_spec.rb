# frozen_string_literal: true

require_relative "../lib/check"

describe Check do
  subject(:new_board_white) { described_class.new("white") }

  describe "#check?" do
    context "when the king is not in check" do
      it "returns false" do
        no_check_board = described_class.new("white", "kq6/2p5/rnb5/8/8/8/8/6K1")
        expect(no_check_board.check?).to eq(false)
      end
    end

    context "when new board, white" do
      it "returns false" do
        expect(new_board_white.check?).to eq(false)
      end
    end

    context "when new board, black" do
      it "returns false" do
        new_board_black = described_class.new("black")
        expect(new_board_black.check?).to eq(false)
      end
    end

    context "when checked by a rook" do
      it "returns true" do
        rook_check_board = described_class.new("white", "k7/6r1/8/8/8/8/8/6K1")
        expect(rook_check_board.check?).to eq(true)
      end
    end

    context "when rook is blocked by a pawn" do
      it "returns false" do
        no_rook_check_board = described_class.new("white", "k7/6r1/8/6p1/8/8/8/6K1")
        expect(no_rook_check_board.check?).to eq(false)
      end
    end

    context "when checked by a knight" do
      it "returns true" do
        knight_check_board = described_class.new("black", "k7/8/1N6/8/8/8/8/6K1")
        expect(knight_check_board.check?).to eq(true)
      end
    end

    context "when checked by a bishop" do
      it "returns true" do
        bishop_check = described_class.new("black", "k7/8/8/3B4/8/8/8/6K1")
        expect(bishop_check.check?).to eq(true)
      end
    end

    context "when checked by a queen" do
      it "returns true" do
        queen_check = described_class.new("white", "k7/8/8/8/8/8/8/3q2K1")
        expect(queen_check.check?).to eq(true)
      end
    end

    context "when checked by a white pawn" do
      it "returns true" do
        white_pawn_check = described_class.new("black", "k7/1P6/8/8/8/8/8/6K1")
        expect(white_pawn_check.check?).to eq(true)
      end
    end

    context "when checked by a black pawn" do
      it "returns true" do
        black_pawn_check = described_class.new("white", "k7/8/8/8/8/8/5p2/6K1")
        expect(black_pawn_check.check?).to eq(true)
      end
    end
  end

  describe "#checking_pieces" do
    context "when no checking pieces" do
      it "returns an empty array []" do
        expect(new_board_white.checking_pieces).to eq([])
      end
    end

    context "when multiple checking pieces" do
      it "returns an array with all the checking pieces" do
        multiple_check_board = described_class.new("white", "k1q5/8/8/8/4bp2/6n1/8/7K")
        expect(multiple_check_board.checking_pieces.length).to eq(2)
      end
    end
  end

end