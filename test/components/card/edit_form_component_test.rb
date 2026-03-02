require "test_helper"

class Card::EditFormComponentTest < ViewComponent::TestCase
  test "renders form with title, description, label fields" do
    board = boards(:demo)
    card = cards(:first_card)
    render_inline(Card::EditFormComponent.new(card: card, board: board))

    assert_selector "input[name='card[title]']"
    assert_selector "textarea[name='card[description]']"
    assert_selector "select[name='card[label]']"
  end

  test "has turbo frame wrapper matching card id" do
    board = boards(:demo)
    card = cards(:first_card)
    render_inline(Card::EditFormComponent.new(card: card, board: board))

    assert_selector "turbo-frame[id='card_#{card.id}']"
  end

  test "has card-editor controller data attribute" do
    board = boards(:demo)
    card = cards(:first_card)
    render_inline(Card::EditFormComponent.new(card: card, board: board))

    assert_selector "[data-controller='card-editor']"
  end
end
