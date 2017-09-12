require "player_ui_builder"
require "player_ui"
require "board"

describe PlayerUIBuilder do
  describe "#build" do
    it "builds PlayerUI" do
      builder = PlayerUIBuilder.new
      board_ui = builder.set_board(Board.new).build
      expect(board_ui).to be_an_instance_of(PlayerUI)
    end
  end
end