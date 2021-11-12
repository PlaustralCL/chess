# frozen_string_literal: true

require_relative "../lib/queen_move"

describe QueenMove do
  describe "#basic_rules?" do
    subject(:new_board) { described_class.new }

    context "queen moves from e5 to e8" do
      it "returns true" do
        new_board.update_start_square("e5")
        new_board.update_finish_square("e8")
        expect(new_board.basic_rules?).to eq(true)
      end
    end

    context "queen moves from e5 to h8" do
      it "returns true" do
        new_board.update_start_square("e5")
        new_board.update_finish_square("h8")
        expect(new_board.basic_rules?).to eq(true)
      end
    end

    context "queen moves from e5 to h5" do
      it "returns true" do
        new_board.update_start_square("e5")
        new_board.update_finish_square("h5")
        expect(new_board.basic_rules?).to eq(true)
      end
    end

    context "queen moves from e5 to g3" do
      it "returns true" do
        new_board.update_start_square("e5")
        new_board.update_finish_square("g3")
        expect(new_board.basic_rules?).to eq(true)
      end
    end

    context "queen moves from e5 to e2" do
      it "returns true" do
        new_board.update_start_square("e5")
        new_board.update_finish_square("e2")
        expect(new_board.basic_rules?).to eq(true)
      end
    end

    context "queen moves from e5 to b2" do
      it "returns true" do
        new_board.update_start_square("e5")
        new_board.update_finish_square("b2")
        expect(new_board.basic_rules?).to eq(true)
      end
    end

    context "queen moves from e5 to a5" do
      it "returns true" do
        new_board.update_start_square("e5")
        new_board.update_finish_square("a5")
        expect(new_board.basic_rules?).to eq(true)
      end
    end

    context "queen moves from e5 to b8" do
      it "returns true" do
        new_board.update_start_square("e5")
        new_board.update_finish_square("b8")
        expect(new_board.basic_rules?).to eq(true)
      end
    end

    context "queen moves from e5 to c4" do
      it "returns false" do
        new_board.update_start_square("e5")
        new_board.update_finish_square("c4")
        expect(new_board.basic_rules?).to eq(false)
      end
    end
  end

  describe "clear_path?" do
    subject(:queen_obstructions) { described_class.new("1p2p2p/2P1P3/5P2/pP2Q1Pp/5P2/2P1P1p1/1p2p3/8") }

    context "queen moves from e5 to e8" do
      it "returns false" do
        queen_obstructions.update_start_square("e5")
        queen_obstructions.update_finish_square("e8")
        expect(queen_obstructions.clear_path?).to eq(false)
      end
    end

    context "queen moves from e5 to h8" do
      it "returns false" do
        queen_obstructions.update_start_square("e5")
        queen_obstructions.update_finish_square("h8")
        expect(queen_obstructions.clear_path?).to eq(false)
      end
    end

    context "queen moves from e5 to h5" do
      it "returns false" do
        queen_obstructions.update_start_square("e5")
        queen_obstructions.update_finish_square("h5")
        expect(queen_obstructions.clear_path?).to eq(false)
      end
    end

    context "queen moves from e5 to g3" do
      it "returns false" do
        queen_obstructions.update_start_square("e5")
        queen_obstructions.update_finish_square("g3")
        expect(queen_obstructions.clear_path?).to eq(false)
      end
    end

    context "queen moves from e5 to e2" do
      it "returns false" do
        queen_obstructions.update_start_square("e5")
        queen_obstructions.update_finish_square("e2")
        expect(queen_obstructions.clear_path?).to eq(false)
      end
    end

    context "queen moves from e5 to b2" do
      it "returns false" do
        queen_obstructions.update_start_square("e5")
        queen_obstructions.update_finish_square("b2")
        expect(queen_obstructions.clear_path?).to eq(false)
      end
    end

    context "queen moves from e5 to a5" do
      it "returns false" do
        queen_obstructions.update_start_square("e5")
        queen_obstructions.update_finish_square("a5")
        expect(queen_obstructions.clear_path?).to eq(false)
      end
    end

    context "queen moves from e5 to b8" do
      it "returns false" do
        queen_obstructions.update_start_square("e5")
        queen_obstructions.update_finish_square("b8")
        expect(queen_obstructions.clear_path?).to eq(false)
      end
    end

    context "queen moves from e5 to c5" do
      it "returns true" do
        queen_obstructions.update_start_square("e5")
        queen_obstructions.update_finish_square("c5")
        expect(queen_obstructions.clear_path?).to eq(true)
      end
    end

  end
end
