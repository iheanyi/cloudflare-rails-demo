class Card::EditFormComponent < ViewComponent::Base
  include ActionView::RecordIdentifier
  include Turbo::FramesHelper

  def initialize(card:, board:)
    @card = card
    @board = board
  end
end
