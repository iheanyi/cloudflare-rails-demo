class BoardColumn < ApplicationRecord
  belongs_to :board
  has_many :cards, -> { order(position: :asc) }, dependent: :destroy

  acts_as_list scope: :board

  validates :name, presence: true
  validates :position, presence: true
end
