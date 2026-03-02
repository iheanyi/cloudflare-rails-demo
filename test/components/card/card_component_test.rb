require "test_helper"

class Card::CardComponentTest < ViewComponent::TestCase
  test "renders card title" do
    board = boards(:demo)
    card = cards(:first_card)
    render_inline(Card::CardComponent.new(card: card, board: board))

    assert_text card.title
  end

  test "renders label badge when label present" do
    board = boards(:demo)
    card = cards(:first_card)
    render_inline(Card::CardComponent.new(card: card, board: board))

    assert_selector "span.rounded-full", text: card.label
  end

  test "renders description when present" do
    board = boards(:demo)
    card = cards(:first_card)
    render_inline(Card::CardComponent.new(card: card, board: board))

    assert_text card.description
  end

  test "has turbo frame wrapper with correct id" do
    board = boards(:demo)
    card = cards(:first_card)
    render_inline(Card::CardComponent.new(card: card, board: board))

    assert_selector "turbo-frame[id='card_#{card.id}']"
  end

  test "has data-card-id attribute" do
    board = boards(:demo)
    card = cards(:first_card)
    render_inline(Card::CardComponent.new(card: card, board: board))

    assert_selector "[data-card-id='#{card.id}']"
  end
end
