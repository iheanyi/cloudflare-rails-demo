require "test_helper"

class Board::HeaderComponentTest < ViewComponent::TestCase
  test "renders board name" do
    board = boards(:demo)
    render_inline(Board::HeaderComponent.new(board: board))

    assert_selector "h1", text: board.name
  end

  test "renders the tech badge text" do
    board = boards(:demo)
    render_inline(Board::HeaderComponent.new(board: board))

    assert_text "Rails 8 + Cloudflare Containers"
  end
end
