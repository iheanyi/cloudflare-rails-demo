require "test_helper"

class Card::NewFormComponentTest < ViewComponent::TestCase
  test "renders add card button" do
    board = boards(:demo)
    column = board_columns(:backlog)
    render_inline(Card::NewFormComponent.new(column: column, board: board))

    assert_selector "button", text: "Add Card"
  end

  test "has new-card controller data attribute" do
    board = boards(:demo)
    column = board_columns(:backlog)
    render_inline(Card::NewFormComponent.new(column: column, board: board))

    assert_selector "[data-controller='new-card']"
  end

  test "has hidden form div" do
    board = boards(:demo)
    column = board_columns(:backlog)
    render_inline(Card::NewFormComponent.new(column: column, board: board))

    assert_selector "div.hidden[data-new-card-target='form']"
  end
end
