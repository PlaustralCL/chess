# frozen_string_literal: true

require_relative "../lib/board"

describe Board do
  subject(:new_board) { described_class.new }

  describe "#initialize" do
    context "when initialized" do
      it "creates a 64 element array" do
        expect(new_board.gameboard.length).to eq(64)
      end

      it "each array element is a Struct" do
        expect(new_board.gameboard).to all(be_kind_of(Struct))
      end
    end
  end

  describe "#assign_square_names" do
    it "assigns a string the the name attribute" do
      name_list = new_board.gameboard.map(&:name)
      expect(name_list).to all(be_kind_of(String))
    end
    it "assigns a8 to element 0" do
      expect(new_board.gameboard[0].name).to eq("a8")
    end

    it "assigns h8 to element 7" do
      expect(new_board.gameboard[7].name).to eq("h8")
    end

    it "assigns h1 to element 63" do
      expect(new_board.gameboard[63].name).to eq("h1")
    end
  end


end
