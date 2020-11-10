class Memo < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  has_many :fav_memos, dependent: :destroy 

  validates :memo_text, presence: true
end
