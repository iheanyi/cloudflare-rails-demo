class Board < ApplicationRecord
  has_many :board_columns, -> { order(position: :asc) }, dependent: :destroy
  has_many :cards, through: :board_columns

  validates :name, presence: true
end
