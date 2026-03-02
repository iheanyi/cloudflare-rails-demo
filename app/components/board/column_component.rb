class Board::ColumnComponent < ViewComponent::Base
  def initialize(board_column:, board:)
    @board_column = board_column
    @board = board
  end
end
