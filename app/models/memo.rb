class Memo < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  validates :memo_text, presence: true
end
