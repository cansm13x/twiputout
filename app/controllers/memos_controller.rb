class MemosController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update]
  before_action :set_item, only: [:edit, :update, :destroy]

  def index
    @memos = Memo.includes(:user).order('created_at DESC')
  end

  def new
    @memo = Memo.new
  end

  def create
    @memo = Memo.new(memo_params)
    if @memo.save
      redirect_to root_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @memo.update(memo_params)
      redirect_to root_path
    else
      render :edit
    end
  end

  def destroy
    @memo.destroy
    redirect_to root_path
  end

  private

  def memo_params
    params.require(:memo).permit(:memo_text, :image).merge(user_id: current_user.id)
  end

  def set_item
    @memo = Memo.find(params[:id])
  end
end
