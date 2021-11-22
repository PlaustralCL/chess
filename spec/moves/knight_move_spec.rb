# frozen_string_literal: true

require_relative "../../lib/moves/knight_move"

describe KnightMove do
  subject(:new_board) { described_class.new }

  describe "basic_rules" do
    context "when knight moves e5 to f7" do
      it "returns true" do
        new_board.update_start_square("e5")
        new_board.update_finish_square("f7")
        expect(new_board.basic_rules?).to eq(true)
      end
    end

    context "when knight moves e5 to g6" do
      it "returns true" do
        new_board.update_start_square("e5")
        new_board.update_finish_square("g6")
        expect(new_board.basic_rules?).to eq(true)
      end
    end

    context "when knight moves e5 to g4" do
      it "returns true" do
        new_board.update_start_square("e5")
        new_board.update_finish_square("g4")
        expect(new_board.basic_rules?).to eq(true)
      end
    end

    context "when knight moves e5 to f3" do
      it "returns true" do
        new_board.update_start_square("e5")
        new_board.update_finish_square("f3")
        expect(new_board.basic_rules?).to eq(true)
      end
    end

    context "when knight moves e5 to d3" do
      it "returns true" do
        new_board.update_start_square("e5")
        new_board.update_finish_square("d3")
        expect(new_board.basic_rules?).to eq(true)
      end
    end

    context "when knight moves e5 to c4" do
      it "returns true" do
        new_board.update_start_square("e5")
        new_board.update_finish_square("c4")
        expect(new_board.basic_rules?).to eq(true)
      end
    end

    context "when knight moves e5 to c6" do
      it "returns true" do
        new_board.update_start_square("e5")
        new_board.update_finish_square("c6")
        expect(new_board.basic_rules?).to eq(true)
      end
    end

    context "when knight moves e5 to d7" do
      it "returns true" do
        new_board.update_start_square("e5")
        new_board.update_finish_square("d7")
        expect(new_board.basic_rules?).to eq(true)
      end
    end

    context "when knight moves to an illegal square" do
      it "returns false" do
        new_board.update_start_square("g1")
        new_board.update_finish_square("f2")
        expect(new_board.basic_rules?).to eq(false)
      end
    end
  end

  describe "#clear_path?" do
    context "all paths are clear for a knight" do
      it "returns true" do
        new_board.update_start_square("e5")
        new_board.update_finish_square("d7")
        expect(new_board.clear_path?).to eq(true)
      end
    end
  end

  describe "#safe_king?" do
    context "knight move allows their king to be checked" do
      it "returns false" do
        allow_check = described_class.new("r1bqkbnr/ppp2ppp/2np4/1B2p3/4P3/5N2/PPPP1PPP/RNBQK2R")
        allow_check.update_start_square("c6")
        allow_check.update_finish_square("d4")
        expect(allow_check.safe_king?).to eq(false)
      end
    end
  end

end
