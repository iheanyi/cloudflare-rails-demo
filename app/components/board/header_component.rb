class Board::HeaderComponent < ViewComponent::Base
  def initialize(board:)
    @board = board
  end
end
