class FavMemosController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :set_memo, only: [:create, :destroy]

  def create
    fav_memo = current_user.fav_memos.build(memo_id: params[:memo_id])
    fav_memo.save
    redirect_to root_path
  end

  def destroy
    fav_memo = FavMemo.find_by(memo_id: params[:memo_id], user_id: current_user.id)
    fav_memo.destroy
    redirect_to root_path
  end

  private

  def set_memo
    @memo = Memo.find(params[:memo_id])
  end
end
