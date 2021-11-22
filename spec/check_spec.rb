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

  describe "#checkmate?" do
    context "king not in check" do
      it "returns false" do
        expect(new_board_white.checkmate?).to eq(false)
      end
    end

    context "the king is in checkmate" do
      it "returns true" do
        back_rank_mate = described_class.new("black", "3R2k1/5ppp/8/8/8/8/8/3K4")
        expect(back_rank_mate.checkmate?).to eq(true)
      end
    end

    # capture_checking_piece?
    context "the checking piece can be captured by an ally" do
      it "returns false" do
        rook_check_bishop_capture = described_class.new("black", "5Rk1/6Pp/3b3P/8/8/8/8/3K4")
        expect(rook_check_bishop_capture.checkmate?).to eq(false)
      end
    end

    context "double check" do
      it "returns true" do
        double_check = described_class.new("black", "6rk/5Np1/8/8/8/8/8/6KR")
        expect(double_check.checkmate?).to eq(true)
      end
    end

    context "the checking piece could be captured by the king but it is guarded" do
      it "returns true" do
        rook_guarded = described_class.new("black", "5Rk1/6pp/8/2B5/8/8/8/3K4")
        expect(rook_guarded.checkmate?).to eq(true)
      end
    end

    context "the checking piece cannot be captured" do
      it "returns true" do
        back_rank_mate = described_class.new("black", "3R2k1/5ppp/8/8/8/8/8/3K4")
        expect(back_rank_mate.checkmate?).to eq(true)
      end
    end

    # move the king to a safe square
    context "the checking piece can be captured by the king" do
      it "returns false" do
        rook_check_king_capture = described_class.new("black", "5Rk1/6pp/8/8/8/8/8/3K4")
        expect(rook_check_king_capture.checkmate?).to eq(false)
      end
    end

    context "the king can move to a safe square" do
      it "returns false" do
        escape_square = described_class.new("white", "6k1/8/8/8/8/8/4nPP1/6K1")
        expect(escape_square.checkmate?).to eq(false)
      end
    end

    # block the checking piece
    context "when the checking piece can be blocked" do
      it "returns false" do
        blocking_board_rook = described_class.new("white", "6k1/8/8/8/4R3/8/5PPP/2r3K1")
        expect(blocking_board_rook.checkmate?).to eq(false)
      end
    end

    context "when a pawn moves one square to block" do
      it "returns false" do
        blocking_board_pawn = described_class.new("white", "6k1/6r1/2b5/8/8/7P/5P1P/7K")
        expect(blocking_board_pawn.checkmate?).to eq(false)
      end
    end

    context "when a pawn moves two square to block" do
      it "returns false" do
        blocking_board_pawn = described_class.new("white", "6k1/6r1/3b4/8/8/7P/5P1K/7R")
        expect(blocking_board_pawn.checkmate?).to eq(false)
      end
    end

    context "smothered mate" do
      it "returns true" do
        smothered_mate = described_class.new("white", "6k1/8/8/8/8/8/5nPP/6RK")
        expect(smothered_mate.checkmate?).to eq(true)
      end
    end

    context "hook mate" do
      it "returns true" do
        hook_mate = described_class.new("black", "4R3/4kp2/5N2/4P3/8/8/8/6K1")
        expect(hook_mate.checkmate?).to eq(true)
      end
    end

    context "anastasia's mate" do
      it "returns true" do
        anastasia_mate = described_class.new("black", "5r2/1b2Nppk/8/7R/8/8/5PPP/6K1")
        expect(anastasia_mate.checkmate?).to eq(true)
      end
    end

    context "boden's mate" do
      it "returns true" do
        bowdens_mate = described_class.new("white", "2k1r2r/ppp3pp/2n5/3B1b2/5P2/b1P1BQ2/P2N1P1P/2KR3R")
        expect(bowdens_mate.checkmate?).to eq(true)
      end
    end

  end

end