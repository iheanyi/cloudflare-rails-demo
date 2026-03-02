class CardsController < ApplicationController
  before_action :set_board
  before_action :set_card, only: [ :edit, :update, :destroy, :move ]

  def create
    @column = @board.board_columns.find(params[:card][:board_column_id])
    @card = @column.cards.build(card_params)

    if @card.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to board_path(@board) }
      end
    else
      head :unprocessable_entity
    end
  end

  def edit
    render layout: false
  end

  def update
    if @card.update(card_params)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to board_path(@board) }
      end
    else
      render :edit, status: :unprocessable_entity, layout: false
    end
  end

  def destroy
    @card.destroy

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to board_path(@board) }
    end
  end

  def move
    new_column = @board.board_columns.find(params[:card][:board_column_id])
    new_position = params[:card][:position].to_i

    ActiveRecord::Base.transaction do
      if @card.board_column_id != new_column.id
        @card.remove_from_list
        @card.update_column(:board_column_id, new_column.id)
        @card.reload
      end
      @card.insert_at(new_position)
    end

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to board_path(@board) }
    end
  end

  private

  def set_board
    @board = Board.find(params[:board_id])
  end

  def set_card
    @card = @board.cards.find(params[:id])
  end

  def card_params
    params.require(:card).permit(:title, :description, :label, :board_column_id)
  end
end
