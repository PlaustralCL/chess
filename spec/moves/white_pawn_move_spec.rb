# frozen_string_literal: true

require_relative "../../lib/moves/white_pawn_move"

describe WhitePawnMove do
  subject(:basic_board) { described_class.new("8/P7/1P3p1p/6P1/8/2P5/4P3/8") }

  describe "#basic_rules?" do
    # starting position
    context "pawn moves from e2 to e4" do
      it "returns true" do
        basic_board.update_start_square("e2")
        basic_board.update_finish_square("e4")
        expect(basic_board.basic_rules?).to eq(true)
      end
    end

    context "pawn moves from e2 to e3" do
      it "returns true" do
        basic_board.update_start_square("e2")
        basic_board.update_finish_square("e3")
        expect(basic_board.basic_rules?).to eq(true)
      end
    end

    context "pawn mves from e2 to e5" do
      it "returns false" do
        basic_board.update_start_square("e2")
        basic_board.update_finish_square("e5")
        expect(basic_board.basic_rules?).to eq(false)
      end
    end

    context "pawn mves from e2 to e1" do
      it "returns false" do
        basic_board.update_start_square("e2")
        basic_board.update_finish_square("e1")
        expect(basic_board.basic_rules?).to eq(false)
      end
    end

    context "pawn mves from e2 to g3" do
      it "returns false" do
        basic_board.update_start_square("e2")
        basic_board.update_finish_square("g3")
        expect(basic_board.basic_rules?).to eq(false)
      end
    end

    # normal move
    context "pawn moves from c3 to c5" do
      it "returns false" do
        basic_board.update_start_square("c3")
        basic_board.update_finish_square("c5")
        expect(basic_board.basic_rules?).to eq(false)
      end
    end

    context "pawn moves from c3 to c4" do
      it "returns true" do
        basic_board.update_start_square("c3")
        basic_board.update_finish_square("c4")
        expect(basic_board.basic_rules?).to eq(true)
      end
    end

    context "pawn moves from c3 to c2" do
      it "returns false" do
        basic_board.update_start_square("c3")
        basic_board.update_finish_square("c2")
        expect(basic_board.basic_rules?).to eq(false)
      end
    end

    context "pawn moves from c3 to a4" do
      it "returns false" do
        basic_board.update_start_square("c3")
        basic_board.update_finish_square("a4")
        expect(basic_board.basic_rules?).to eq(false)
      end
    end

    # capture
    context "pawn captures from g5 to f6" do
      it "returns true" do
        basic_board.update_start_square("g5")
        basic_board.update_finish_square("f6")
        expect(basic_board.basic_rules?).to eq(true)
      end
    end

    context "pawn captures from g5 to h6" do
      it "returns true" do
        basic_board.update_start_square("g5")
        basic_board.update_finish_square("h6")
        expect(basic_board.basic_rules?).to eq(true)
      end
    end

    context "pawn moves diagonally when no piece to capture" do
      it "returns false" do
        basic_board.update_start_square("c3")
        basic_board.update_finish_square("b4")
        expect(basic_board.basic_rules?).to eq(false)
      end
    end

    context "pawn trys to capture own piece" do
      it "returns false" do
        basic_board.update_start_square("b6")
        basic_board.update_finish_square("a7")
        expect(basic_board.basic_rules?).to eq(false)
      end
    end

    context "pawn moves diagonally backward" do
      it "returns false" do
        basic_board.update_start_square("g5")
        basic_board.update_finish_square("f4")
        expect(basic_board.basic_rules?).to eq(false)
      end
    end

    # en_passant?
    context "when en passant is allowed for white" do
      it "returns true" do
        ep_allowed = described_class.new("rnbqkbnr/pp2p1pp/2p5/3pPp2/3P4/8/PPP2PPP/RNBQKBNR w KQkq f6 0 4")
        ep_allowed.update_start_square("e5")
        ep_allowed.update_finish_square("f6")
        expect(ep_allowed.basic_rules?).to eq(true)
      end
    end
  end

  describe "#clear_path?" do
    subject(:pawn_obstructions) { described_class.new("8/2p5/8/2P5/P3p3/P4p2/4PP1P/8") }

    context "pawn move from f2 to f4, black pawn on f3" do
      it "returns false" do
        pawn_obstructions.update_start_square("f2")
        pawn_obstructions.update_finish_square("f4")
        expect(pawn_obstructions.clear_path?).to eq(false)
      end
    end

    context "pawn move from a3 to a4, white pawn on e3" do
      it "returns false" do
        pawn_obstructions.update_start_square("a3")
        pawn_obstructions.update_finish_square("a4")
        expect(pawn_obstructions.clear_path?).to eq(false)
      end
    end

    context "pawn move from e2 to e3" do
      it "returns true" do
        pawn_obstructions.update_start_square("e2")
        pawn_obstructions.update_finish_square("e3")
        expect(pawn_obstructions.clear_path?).to eq(true)
      end
    end

    context "pawn move from h2 to h4, no obstructions" do
      it "returns true" do
        pawn_obstructions.update_start_square("h2")
        pawn_obstructions.update_finish_square("h4")
        expect(pawn_obstructions.clear_path?).to eq(true)
      end
    end

    context "pawn c5-c6, black pawn on c7" do
      it "returns true" do
        pawn_obstructions.update_start_square("c5")
        pawn_obstructions.update_finish_square("c6")
        expect(pawn_obstructions.clear_path?).to eq(true)
      end
    end
  end

  describe "#en_passant?" do
    context "when en passant is allowed for white" do
      it "returns true" do
        ep_allowed = described_class.new("rnbqkbnr/pp2p1pp/2p5/3pPp2/3P4/8/PPP2PPP/RNBQKBNR w KQkq f6 0 4")
        ep_allowed.update_start_square("e5")
        ep_allowed.update_finish_square("f6")
        expect(ep_allowed.en_passant?).to eq(true)
      end
    end

    context "when en passant is not allowed" do
      it "returns false" do
        ep_not_allowed = described_class.new("rnbqkbnr/pp2p1pp/2p5/3pPp2/3P4/P7/1PP2PPP/RNBQKBNR w KQkq - 0 5")
        ep_not_allowed.update_start_square("e5")
        ep_not_allowed.update_finish_square("f6")
        expect(ep_not_allowed.en_passant?).to eq(false)
      end
    end
  end
end
