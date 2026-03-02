class BoardsController < ApplicationController
  def show
    @board = if params[:id]
      Board.find(params[:id])
    else
      Board.first!
    end

    @board_columns = @board.board_columns.includes(:cards)
  end
end
