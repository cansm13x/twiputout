class MemosController < ApplicationController
  def index
  end

  private

  def memo_params
    params.require(:memo).permit(:memo_text, :image).marge(user_id: current_user.id)
  end
end
