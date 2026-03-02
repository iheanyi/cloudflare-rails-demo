require "test_helper"

class BoardTest < ActiveSupport::TestCase
  test "validates name presence" do
    board = Board.new(name: nil)
    assert_not board.valid?
    assert_includes board.errors[:name], "can't be blank"
  end

  test "has many board_columns" do
    board = boards(:demo)
    assert_respond_to board, :board_columns
    assert_includes board.board_columns, board_columns(:backlog)
  end

  test "has many cards through board_columns" do
    board = boards(:demo)
    assert_respond_to board, :cards
    assert_includes board.cards, cards(:first_card)
  end
end
