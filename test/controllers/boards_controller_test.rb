require "test_helper"

class BoardsControllerTest < ActionDispatch::IntegrationTest
  test "GET show with id renders successfully" do
    board = boards(:demo)
    get board_path(board)
    assert_response :success
  end

  test "GET root path renders successfully" do
    get root_path
    assert_response :success
  end

  test "show loads board with columns" do
    board = boards(:demo)
    get board_path(board)
    assert_response :success
    assert_select "h1", board.name
  end
end
