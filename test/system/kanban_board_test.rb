require "application_system_test_case"

class KanbanBoardTest < ApplicationSystemTestCase
  setup do
    @board = boards(:demo)
  end

  test "board page loads with columns" do
    visit board_path(@board)
    assert_selector "h1", text: @board.name
  end

  test "columns display correct names" do
    visit board_path(@board)
    assert_selector "h2", text: "Backlog"
    assert_selector "h2", text: "In Progress"
  end

  test "cards are visible within columns" do
    visit board_path(@board)
    assert_text "First task"
    assert_text "Working on it"
  end
end
