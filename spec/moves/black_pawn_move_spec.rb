# frozen_string_literal: true

require_relative "../../lib/moves/black_pawn_move"

describe BlackPawnMove do
  subject(:basic_board) { described_class.new("8/4p3/2p5/8/6p1/1p3P1P/p7/8") }

  describe "#basic_rules?" do
    # starting position
    context "pawn moves from e7 to e5" do
      it "returns true" do
        basic_board.update_start_square("e7")
        basic_board.update_finish_square("e5")
        expect(basic_board.basic_rules?).to eq(true)
      end
    end

    context "pawn moves from e7 to e6" do
      it "returns true" do
        basic_board.update_start_square("e7")
        basic_board.update_finish_square("e6")
        expect(basic_board.basic_rules?).to eq(true)
      end
    end

    context "pawn mves from e7 to e5" do
      it "returns false" do
        basic_board.update_start_square("e7")
        basic_board.update_finish_square("e4")
        expect(basic_board.basic_rules?).to eq(false)
      end
    end

    context "pawn mves from e7 to e8" do
      it "returns false" do
        basic_board.update_start_square("e7")
        basic_board.update_finish_square("e8")
        expect(basic_board.basic_rules?).to eq(false)
      end
    end

    context "pawn mves from e7 to g6" do
      it "returns false" do
        basic_board.update_start_square("e7")
        basic_board.update_finish_square("g6")
        expect(basic_board.basic_rules?).to eq(false)
      end
    end

    # normal move
    context "pawn moves from c6 to c4" do
      it "returns false" do
        basic_board.update_start_square("c6")
        basic_board.update_finish_square("c4")
        expect(basic_board.basic_rules?).to eq(false)
      end
    end

    context "pawn moves from c6 to c5" do
      it "returns true" do
        basic_board.update_start_square("c6")
        basic_board.update_finish_square("c5")
        expect(basic_board.basic_rules?).to eq(true)
      end
    end

    context "pawn moves from c6 to c7" do
      it "returns false" do
        basic_board.update_start_square("c6")
        basic_board.update_finish_square("c7")
        expect(basic_board.basic_rules?).to eq(false)
      end
    end

    context "pawn moves from c6 to a5" do
      it "returns false" do
        basic_board.update_start_square("c6")
        basic_board.update_finish_square("a5")
        expect(basic_board.basic_rules?).to eq(false)
      end
    end

    # capture
    context "pawn captures from g4 to f3" do
      it "returns true" do
        basic_board.update_start_square("g4")
        basic_board.update_finish_square("f3")
        expect(basic_board.basic_rules?).to eq(true)
      end
    end

    context "pawn captures from g4 to h3" do
      it "returns true" do
        basic_board.update_start_square("g4")
        basic_board.update_finish_square("h3")
        expect(basic_board.basic_rules?).to eq(true)
      end
    end

    context "pawn moves diagonally when no piece to capture" do
      it "returns false" do
        basic_board.update_start_square("c6")
        basic_board.update_finish_square("b5")
        expect(basic_board.basic_rules?).to eq(false)
      end
    end

    context "pawn trys to capture own piece" do
      it "returns false" do
        basic_board.update_start_square("b3")
        basic_board.update_finish_square("a2")
        expect(basic_board.basic_rules?).to eq(false)
      end
    end

    context "pawn moves diagonally backward" do
      it "returns false" do
        basic_board.update_start_square("g4")
        basic_board.update_finish_square("f5")
        expect(basic_board.basic_rules?).to eq(false)
      end
    end
  end

  describe "#clear_path?" do
    subject(:pawn_obstructions) { described_class.new("8/4pp1p/p4P2/p3P3/2p5/8/2P5/8") }

    context "pawn move from f7 to f5, white pawn on f6" do
      it "returns false" do
        pawn_obstructions.update_start_square("f7")
        pawn_obstructions.update_finish_square("f5")
        expect(pawn_obstructions.clear_path?).to eq(false)
      end
    end

    context "pawn move from a6 to a5, white pawn on a5" do
      it "returns false" do
        pawn_obstructions.update_start_square("a6")
        pawn_obstructions.update_finish_square("a5")
        expect(pawn_obstructions.clear_path?).to eq(false)
      end
    end

    context "pawn move from e7 to f6" do
      it "returns true" do
        pawn_obstructions.update_start_square("e7")
        pawn_obstructions.update_finish_square("f6")
        expect(pawn_obstructions.clear_path?).to eq(true)
      end
    end

    context "pawn move from h7 to h5, no obstructions" do
      it "returns true" do
        pawn_obstructions.update_start_square("h7")
        pawn_obstructions.update_finish_square("h5")
        expect(pawn_obstructions.clear_path?).to eq(true)
      end
    end

    context "pawn c4-c3, white pawn on c2" do
      it "returns true" do
        pawn_obstructions.update_start_square("c4")
        pawn_obstructions.update_finish_square("c3")
        expect(pawn_obstructions.clear_path?).to eq(true)
      end
    end
  end

  describe "#valid_move" do
    context "when pinned pawn tries to move" do
      it "returns false" do
        pinned_bishop = described_class.new("5k2/8/5p2/4P3/8/8/5R2/6K1")
        expect(pinned_bishop.valid_move?("f6", "e5")).to eq(false)
      end
    end

    context "when non-pinned bishop tries to move" do
      it "returns true" do
        pinned_bishop = described_class.new("5k2/8/5p2/4P3/8/8/8/6K1")
        expect(pinned_bishop.valid_move?("f6", "e5")).to eq(true)
      end
    end
  end
end
