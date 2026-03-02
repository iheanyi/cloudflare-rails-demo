class Card::NewFormComponent < ViewComponent::Base
  def initialize(column:, board:)
    @column = column
    @board = board
  end
end
