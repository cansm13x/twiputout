class FavMemo < ApplicationRecord
  belongs_to :user
  belongs_to :memo
end
