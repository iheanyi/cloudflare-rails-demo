require "test_helper"

class BoardColumnTest < ActiveSupport::TestCase
  test "validates name presence" do
    column = BoardColumn.new(board: boards(:demo), name: nil, position: 1)
    assert_not column.valid?
    assert_includes column.errors[:name], "can't be blank"
  end

  test "validates position presence" do
    column = BoardColumn.new(board: boards(:demo), name: "Test", position: nil)
    assert_not column.valid?
    assert_includes column.errors[:position], "can't be blank"
  end

  test "belongs to board" do
    column = board_columns(:backlog)
    assert_equal boards(:demo), column.board
  end

  test "has many cards" do
    column = board_columns(:backlog)
    assert_respond_to column, :cards
    assert_includes column.cards, cards(:first_card)
  end

  test "acts_as_list ordering works" do
    board = boards(:demo)
    columns = board.board_columns.order(:position)
    assert_equal board_columns(:backlog), columns.first
    assert_equal board_columns(:in_progress), columns.second
  end
end
