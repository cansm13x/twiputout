class Memo < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  has_many :fav_memos, dependent: :destroy 

  validates :memo_text, presence: true

  def liked_by?(user)
    fav_memos.where(user_id: user.id).exists?
  end
end