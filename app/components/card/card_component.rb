class Card::CardComponent < ViewComponent::Base
  include ActionView::RecordIdentifier
  include Turbo::FramesHelper

  def initialize(card:, board:)
    @card = card
    @board = board
  end

  private

  def label_color
    @card.label_color || Card::LABELS[@card.label]
  end

  def time_ago
    seconds = Time.current - @card.created_at
    if seconds < 60
      "just now"
    elsif seconds < 3600
      "#{(seconds / 60).to_i}m ago"
    elsif seconds < 86400
      "#{(seconds / 3600).to_i}h ago"
    else
      "#{(seconds / 86400).to_i}d ago"
    end
  end
end
