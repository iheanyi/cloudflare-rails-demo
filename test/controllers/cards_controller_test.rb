require "test_helper"

class CardsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @board = boards(:demo)
    @column = board_columns(:backlog)
    @card = cards(:first_card)
  end

  test "POST create with valid params creates card and responds with turbo_stream" do
    assert_difference "Card.count", 1 do
      post board_cards_path(@board), params: {
        card: { title: "New card", board_column_id: @column.id }
      }, as: :turbo_stream
    end

    assert_response :success
    assert_includes response.media_type, "turbo-stream"
  end

  test "POST create with missing title returns unprocessable_entity" do
    assert_no_difference "Card.count" do
      post board_cards_path(@board), params: {
        card: { title: "", board_column_id: @column.id }
      }, as: :turbo_stream
    end

    assert_response :unprocessable_entity
  end

  test "GET edit renders successfully" do
    get edit_board_card_path(@board, @card)
    assert_response :success
  end

  test "PATCH update with valid params updates card" do
    patch board_card_path(@board, @card), params: {
      card: { title: "Updated title" }
    }, as: :turbo_stream

    assert_response :success
    assert_equal "Updated title", @card.reload.title
  end

  test "PATCH update with invalid params returns unprocessable_entity" do
    patch board_card_path(@board, @card), params: {
      card: { title: "" }
    }, as: :turbo_stream

    assert_response :unprocessable_entity
  end

  test "DELETE destroy removes card" do
    assert_difference "Card.count", -1 do
      delete board_card_path(@board, @card), as: :turbo_stream
    end

    assert_response :success
  end

  test "PATCH move moves card to new column with new position" do
    new_column = board_columns(:in_progress)

    patch move_board_card_path(@board, @card), params: {
      card: { board_column_id: new_column.id, position: 1 }
    }, as: :turbo_stream

    assert_response :success
    @card.reload
    assert_equal new_column.id, @card.board_column_id
  end

  test "PATCH move reorders card within same column" do
    patch move_board_card_path(@board, @card), params: {
      card: { board_column_id: @column.id, position: 2 }
    }, as: :turbo_stream

    assert_response :success
    assert_equal 2, @card.reload.position
  end
end
