require "test_helper"

class KanbanBoardFlowTest < ActionDispatch::IntegrationTest
  setup do
    @board = boards(:demo)
    @column = board_columns(:backlog)
    @card = cards(:first_card)
  end

  test "visit board show page successfully" do
    get board_path(@board)
    assert_response :success
  end

  test "create a new card via POST with turbo_stream response" do
    assert_difference "Card.count", 1 do
      post board_cards_path(@board), params: {
        card: { title: "Integration card", board_column_id: @column.id }
      }, as: :turbo_stream
    end

    assert_response :success
    assert_includes response.media_type, "turbo-stream"
  end

  test "update a card with turbo_stream response" do
    patch board_card_path(@board, @card), params: {
      card: { title: "Updated via integration" }
    }, as: :turbo_stream

    assert_response :success
    assert_includes response.media_type, "turbo-stream"
    assert_equal "Updated via integration", @card.reload.title
  end

  test "delete a card with turbo_stream response" do
    assert_difference "Card.count", -1 do
      delete board_card_path(@board, @card), as: :turbo_stream
    end

    assert_response :success
    assert_includes response.media_type, "turbo-stream"
  end

  test "move a card between columns with turbo_stream response" do
    new_column = board_columns(:in_progress)

    patch move_board_card_path(@board, @card), params: {
      card: { board_column_id: new_column.id, position: 1 }
    }, as: :turbo_stream

    assert_response :success
    assert_includes response.media_type, "turbo-stream"
    assert_equal new_column.id, @card.reload.board_column_id
  end
end
