require "test_helper"

class Board::ColumnComponentTest < ViewComponent::TestCase
  test "renders column name" do
    board = boards(:demo)
    column = board_columns(:backlog)
    render_inline(Board::ColumnComponent.new(board_column: column, board: board))

    assert_selector "h2", text: column.name
  end

  test "renders card count" do
    board = boards(:demo)
    column = board_columns(:backlog)
    render_inline(Board::ColumnComponent.new(board_column: column, board: board))

    assert_selector "span", text: column.cards.size.to_s
  end

  test "renders the color dot" do
    board = boards(:demo)
    column = board_columns(:backlog)
    render_inline(Board::ColumnComponent.new(board_column: column, board: board))

    assert_selector "span.rounded-full[style*='background-color: #{column.color}']"
  end

  test "has sortable data attributes" do
    board = boards(:demo)
    column = board_columns(:backlog)
    render_inline(Board::ColumnComponent.new(board_column: column, board: board))

    assert_selector "[data-controller='sortable']"
  end
end
