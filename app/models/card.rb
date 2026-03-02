class Card < ApplicationRecord
  LABELS = {
    "bug" => "#EF4444",
    "feature" => "#3B82F6",
    "design" => "#8B5CF6",
    "devops" => "#F59E0B",
    "docs" => "#10B981",
    "urgent" => "#DC2626"
  }.freeze

  belongs_to :board_column
  has_one :board, through: :board_column

  acts_as_list scope: :board_column

  validates :title, presence: true
  validates :position, presence: true

  before_validation :set_label_color, if: -> { label.present? && label_color.blank? }

  after_create_commit :broadcast_board_update
  after_update_commit :broadcast_board_update
  after_destroy_commit :broadcast_board_update

  private

  def broadcast_board_update
    board_record = self.board || BoardColumn.find_by(id: board_column_id)&.board
    return unless board_record

    board_record.reload
    Turbo::StreamsChannel.broadcast_replace_to(
      board_record,
      target: "board_#{board_record.id}_columns",
      partial: "boards/columns_container",
      locals: { board: board_record }
    )
  rescue => e
    Rails.logger.warn "Broadcast failed (safe to ignore during seeding): #{e.message}"
  end

  def set_label_color
    self.label_color = LABELS[label]
  end
end
