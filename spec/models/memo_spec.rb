require 'rails_helper'

RSpec.describe Memo, type: :model do
  describe 'メモ投稿' do
    before do
      @memo = FactoryBot.build(:memo)
    end

    context 'メモ投稿がうまくいくとき' do
      it 'memo_textとimageが存在すれば投稿できる' do
        expect(@memo).to be_valid
      end
      it 'memo_textのみあれば投稿できる' do
        @memo.image = ''
        expect(@memo).to be_valid
      end
    end

    context 'メモ投稿がうまくいかないとき' do
      it 'memo_textがないと投稿できない' do
        @memo.memo_text = ''
        @memo.valid?
        expect(@memo.errors.full_messages).to include("Memo text can't be blank")
      end
      it 'ユーザーが紐づいていないと投稿できない' do
        @memo.user = nil
        @memo.valid?
        expect(@memo.errors.full_messages).to include('User must exist')
      end
    end
  end
end
