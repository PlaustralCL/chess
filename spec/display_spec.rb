# frozen_string_literal: true

require_relative "../lib/display"

describe Display do
  context "when a new board is displayed" do
    it "returns a string with proper formatting" do
      new_board = described_class.new
      board_string = "8  \e[1;46m r \e[0m\e[1;37m n \e[0m\e[1;46m b \e[0m\e[1;37m q \e[0m\e[1;46m k \e[0m\e[1;37m b \e[0m\e[1;46m n \e[0m\e[1;37m r \e[0m\n7  \e[1;37m p \e[0m\e[1;46m p \e[0m\e[1;37m p \e[0m\e[1;46m p \e[0m\e[1;37m p \e[0m\e[1;46m p \e[0m\e[1;37m p \e[0m\e[1;46m p \e[0m\n6  \e[1;46m   \e[0m\e[1;37m   \e[0m\e[1;46m   \e[0m\e[1;37m   \e[0m\e[1;46m   \e[0m\e[1;37m   \e[0m\e[1;46m   \e[0m\e[1;37m   \e[0m\n5  \e[1;37m   \e[0m\e[1;46m   \e[0m\e[1;37m   \e[0m\e[1;46m   \e[0m\e[1;37m   \e[0m\e[1;46m   \e[0m\e[1;37m   \e[0m\e[1;46m   \e[0m\n4  \e[1;46m   \e[0m\e[1;37m   \e[0m\e[1;46m   \e[0m\e[1;37m   \e[0m\e[1;46m   \e[0m\e[1;37m   \e[0m\e[1;46m   \e[0m\e[1;37m   \e[0m\n3  \e[1;37m   \e[0m\e[1;46m   \e[0m\e[1;37m   \e[0m\e[1;46m   \e[0m\e[1;37m   \e[0m\e[1;46m   \e[0m\e[1;37m   \e[0m\e[1;46m   \e[0m\n2  \e[1;46m P \e[0m\e[1;37m P \e[0m\e[1;46m P \e[0m\e[1;37m P \e[0m\e[1;46m P \e[0m\e[1;37m P \e[0m\e[1;46m P \e[0m\e[1;37m P \e[0m\n1  \e[1;37m R \e[0m\e[1;46m N \e[0m\e[1;37m B \e[0m\e[1;46m Q \e[0m\e[1;37m K \e[0m\e[1;46m B \e[0m\e[1;37m N \e[0m\e[1;46m R \e[0m\n    a  b  c  d  e  f  g  h"
      expect(new_board.build_display).to eq(board_string)
    end
  end
end
