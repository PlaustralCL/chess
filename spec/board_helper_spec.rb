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

  describe "#write_position" do
    it "writes pieces to correct location" do
      actual_locations = new_board.gameboard.map(&:piece)
      expected_locations = ["r", "n", "b", "q", "k", "b", "n", "r", "p", "p", "p", "p", "p", "p", "p", "p", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "P", "P", "P", "P", "P", "P", "P", "P", "R", "N", "B", "Q", "K", "B", "N", "R"]
      expect(actual_locations).to eq(expected_locations)
    end

    it "assigns correct color to pieces" do
      expected_piece_colors = ["black", "black", "black", "black", "black", "black", "black", "black", "black", "black", "black", "black", "black", "black", "black", "black", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "white", "white", "white", "white", "white", "white", "white", "white", "white", "white", "white", "white", "white", "white", "white", "white"]
      actaul_piece_colors = new_board.gameboard.map(&:piece_color)
      expect(actaul_piece_colors).to eq(expected_piece_colors)
    end
  end

  describe "#process_fen" do
    it "conversts basic position to FEN" do
      kings_only = described_class.new("4k3/8/8/8/8/8/8/4K3")
      position = "4k3/8/8/8/8/8/8/4K3 w - - 0 1"
      fen_hash = { :castling_ability=>"-", :ep_target_square=>"-", :fullmove_clock=>"1", :halfmove_clock=>"0", :piece_position=>"4k3/8/8/8/8/8/8/4K3", :side_to_move=>"w" }
      kings_only.process_fen(position)
      expect(kings_only.fen).to eq(fen_hash)
    end
  end

  describe "#board_to_fen" do
    it "converts the gameboard array to FEN string" do
      kings_only = described_class.new("4k3/8/8/8/8/8/8/4K3")
      expected_fen = "4k3/8/8/8/8/8/8/4K3 w - - 0 1"
      expect(kings_only.board_to_fen).to eq(expected_fen)
    end
  end
end
