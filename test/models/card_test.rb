require "test_helper"

class CardTest < ActiveSupport::TestCase
  test "validates title presence" do
    card = Card.new(board_column: board_columns(:backlog), title: nil)
    assert_not card.valid?
    assert_includes card.errors[:title], "can't be blank"
  end

  test "belongs to board_column" do
    card = cards(:first_card)
    assert_equal board_columns(:backlog), card.board_column
  end

  test "has one board through board_column" do
    card = cards(:first_card)
    assert_equal boards(:demo), card.board
  end

  test "acts_as_list ordering works" do
    column = board_columns(:backlog)
    ordered = column.cards.order(:position)
    assert_equal cards(:first_card), ordered.first
    assert_equal cards(:second_card), ordered.second
  end

  test "auto-sets label_color from LABELS when label present and label_color blank" do
    card = Card.new(
      board_column: board_columns(:backlog),
      title: "Test card",
      label: "bug"
    )
    card.valid?
    assert_equal "#EF4444", card.label_color
  end

  test "does not override label_color when already set" do
    card = Card.new(
      board_column: board_columns(:backlog),
      title: "Test card",
      label: "bug",
      label_color: "#CUSTOM1"
    )
    card.valid?
    assert_equal "#CUSTOM1", card.label_color
  end
end
