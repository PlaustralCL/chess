# frozen_string_literal: true

require_relative "../../lib/moves/king_move"

describe KingMove do
  subject(:basic_king) { described_class.new("8/8/8/8/4K3/8/8/8") }

  describe "basic_rules?" do
    context "when king moves from e4 to e5" do
      it "returns true" do
        basic_king.update_start_square("e4")
        basic_king.update_finish_square("e5")
        expect(basic_king.basic_rules?).to eq(true)
      end
    end

    context "when king moves from e4 to f5" do
      it "returns true" do
        basic_king.update_start_square("e4")
        basic_king.update_finish_square("f5")
        expect(basic_king.basic_rules?).to eq(true)
      end
    end

    context "when king moves from e4 to f4" do
      it "returns true" do
        basic_king.update_start_square("e4")
        basic_king.update_finish_square("f4")
        expect(basic_king.basic_rules?).to eq(true)
      end
    end

    context "when king moves from e4 to f3" do
      it "returns true" do
        basic_king.update_start_square("e4")
        basic_king.update_finish_square("f3")
        expect(basic_king.basic_rules?).to eq(true)
      end
    end

    context "when king moves from e4 to e3" do
      it "returns true" do
        basic_king.update_start_square("e4")
        basic_king.update_finish_square("e3")
        expect(basic_king.basic_rules?).to eq(true)
      end
    end

    context "when king moves from e4 to d3" do
      it "returns true" do
        basic_king.update_start_square("e4")
        basic_king.update_finish_square("d3")
        expect(basic_king.basic_rules?).to eq(true)
      end
    end

    context "when king moves from e4 to d4" do
      it "returns true" do
        basic_king.update_start_square("e4")
        basic_king.update_finish_square("d4")
        expect(basic_king.basic_rules?).to eq(true)
      end
    end

    context "when king moves from e4 to d5" do
      it "returns true" do
        basic_king.update_start_square("e4")
        basic_king.update_finish_square("d5")
        expect(basic_king.basic_rules?).to eq(true)
      end
    end

    context "when king moves from e4 to e7" do
      it "returns true" do
        basic_king.update_start_square("e4")
        basic_king.update_finish_square("e7")
        expect(basic_king.basic_rules?).to eq(false)
      end
    end
  end

  describe "clear_path?" do
    bishop_board = described_class.new("8/2b5/8/8/4K3/8/8/8")

    context "when king moves e4-e5, bishop blocks e5" do
      it "returns false" do
        bishop_board.update_start_square("e4")
        bishop_board.update_finish_square("e5")
        expect(bishop_board.clear_path?).to eq(false)
      end
    end

    context "when king moves e4-d3, bishop blocks e5 and f4" do
      it "returns true" do
        bishop_board.update_start_square("e4")
        bishop_board.update_finish_square("d3")
        expect(bishop_board.clear_path?).to eq(true)
      end
    end

    context "check shadow - when king moves g1-h1, rook blocks h1 from c1" do
      it "returns false" do
        rook_check = described_class.new("6k1/8/8/8/4R3/8/5PPP/2r3K1")
        rook_check.update_start_square("g1")
        rook_check.update_finish_square("h1")
        expect(rook_check.clear_path?).to eq(false)
      end
    end

    context "check shadow - when the king moves f2-g1, checked by bishop on d5" do
      it "returns false" do
        bishop_check = described_class.new("6k1/8/8/2b5/8/8/5KPP/8")
        bishop_check.update_start_square("f2")
        bishop_check.update_finish_square("g1")
        expect(bishop_check.clear_path?).to eq(false)
      end
    end
  end

  describe "#remove_king" do
    context "when king starts on a8" do
      it "replaces king with empty piece '-'" do
        basic_king = described_class.new("K7/8/8/8/8/8/8/8")
        basic_king.update_start_square("a8")
        basic_king.update_finish_square("b8")
        basic_king.remove_king
        expect(basic_king.start_square.piece).to eq("-")
      end
    end

    context "when king starts on a8" do
      it "replaces king with empty piece '-'" do
        basic_king = described_class.new("K7/8/8/8/8/8/8/8")
        basic_king.update_start_square("a8")
        basic_king.update_finish_square("b8")
        basic_king.remove_king
        expect(basic_king.gameboard[0].piece).to eq("-")
      end
    end
  end

end
