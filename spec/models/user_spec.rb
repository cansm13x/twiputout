require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = FactoryBot.build(:user)
  end

  describe 'ユーザー新規登録' do
    context '新規登録がうまくいくとき' do
      it 'user_name、email、passwordとpassword_confirmationが存在すれば登録できる' do
        expect(@user).to be_valid
      end
    end

    context '新規登録がうまくいかないとき' do
      it 'user_nameが空だと登録できない' do
        @user.user_name = ''
        @user.valid?
        expect(@user.errors.full_messages).to include("User name can't be blank")
      end
      it 'user_nameが30文字以上だと登録できない' do
        @user.user_name = 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
        @user.valid?
        expect(@user.errors.full_messages).to include('User name is too long (maximum is 30 characters)')
      end
      it 'emailが空だと登録できない' do
        @user.email = ''
        @user.valid?
        expect(@user.errors.full_messages).to include("Email can't be blank")
      end
      it 'emailに@がないと登録できない' do
        @user.email = 'aaagmail.com'
        @user.valid?
        expect(@user.errors.full_messages).to include('Email is invalid')
      end
      it '重複したemailが存在する場合登録できない' do
        @user.save
        another_user = FactoryBot.build(:user)
        another_user.email = @user.email
        another_user.valid?
        expect(another_user.errors.full_messages).to include('Email has already been taken')
      end
      it 'passwordが空では登録できない' do
        @user.password = ''
        @user.valid?
        expect(@user.errors.full_messages).to include("Password can't be blank")
      end
      it 'paswordが5文字以下であれば登録できない' do
        @user.password = '1234k'
        @user.valid?
        expect(@user.errors.full_messages).to include('Password is too short (minimum is 6 characters)')
      end
      it 'passwordが存在してもpassword_confirmationが空では登録できない' do
        @user.password = '12345k'
        @user.password_confirmation = ''
        @user.valid?
        expect(@user.errors.full_messages).to include("Password confirmation doesn't match Password")
      end
      it 'passwordは半角英語だけだと登録できない' do
        @user.password = 'aaaaaa'
        @user.password_confirmation = 'aaaaaa'
        @user.valid?
        expect(@user.errors.full_messages).to include('Password is invalid')
      end
      it 'passwordは半角数字だけだと登録できない' do
        @user.password = '123456'
        @user.password_confirmation = '123456'
        @user.valid?
        expect(@user.errors.full_messages).to include('Password is invalid')
      end
    end
  end
end
