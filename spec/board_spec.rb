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
    it "assigns a string to the name attribute" do
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

  describe "#assign_coordinates" do
    it "assigns an array to the coorinates attribute" do
      coordinates_list = new_board.gameboard.map(&:coordinates)
      expect(coordinates_list).to all(be_kind_of(Array))
    end

    it "assigns [0, 0] to element 0" do
      expect(new_board.gameboard[0].coordinates).to eq([0, 0])
    end

    it "assigns [0, 7] to element 7" do
      expect(new_board.gameboard[7].coordinates).to eq([0, 7])
    end

    it "assigns [7, 7] to element 63" do
      expect(new_board.gameboard[63].coordinates).to eq([7, 7])
    end
  end


end
