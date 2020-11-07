class MemosController < ApplicationController
  before_action :authenticate_user!, only: [:new]

  def index
  end

  def new
    @memo = Memo.new
  end

  private

  def memo_params
    params.require(:memo).permit(:memo_text, :image).marge(user_id: current_user.id)
  end
end
