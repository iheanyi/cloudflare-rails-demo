class Board::PresenceIndicatorComponent < ViewComponent::Base
  def initialize(board_id:)
    @board_id = board_id
  end
end
