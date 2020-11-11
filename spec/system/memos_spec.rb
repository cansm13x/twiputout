require 'rails_helper'

RSpec.describe "メモ投稿", type: :system do
  before do
    @user = FactoryBot.create(:user)
    @memo_text = Faker::Lorem.sentence
    @memo_image = Faker::Lorem.sentence
  end

  context 'メモ投稿ができるとき'do
    it 'ログインしたユーザーは新規メモ投稿できる' do
      # ログインする
      visit new_user_session_path
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      find('input[name="commit"]').click
      expect(current_path).to eq root_path
      # 新規投稿ページへのリンクがある
      expect(page).to have_content('投稿する')
      # 投稿ページに移動する
      visit new_memo_path
      # フォームに情報を入力する★再度確認！！！
      fill_in 'memo_memo_text', with: @memo_text
      # fill_in 'image', with: @memo_image
      # 送信するとMemoモデルのカウントが1上がる
      expect{
        find('input[name="commit"]').click
      }.to change { Memo.count }.by(1)
      # トップページに遷移する
      visit root_path
      # トップページには先ほど投稿した内容のメモが存在する（テキスト）
      expect(page).to have_content(@memo_text)
      # トップページには先ほど投稿した内容のメモが存在する（画像）★再度確認！！！
      # expect(page).to have_selector ".memo_image[src= url(#{@memo_image});']"
    end
  end
  context 'メモ投稿ができないとき'do
    it 'ログインしていないと新規投稿ページに遷移できない' do
      # トップページに遷移する
      visit root_path
      # 新規投稿ページへのリンクがない
      expect(page).to have_no_content('投稿する')
    end
  end
end

RSpec.describe 'メモ編集', type: :system do
  before do
    @user = FactoryBot.create(:user)
    @memo1 = FactoryBot.create(:memo)
    @memo2 = FactoryBot.create(:memo)
  end
  context 'メモ編集ができるとき' do
    it 'ログインしたユーザーは自分が投稿したメモの編集ができる' do
      # メモ1を投稿したユーザーでログインする
      visit new_user_session_path
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      find('input[name="commit"]').click
      expect(current_path).to eq root_path
      # メモ1に「編集」ボタンがある
      expect(
        all(".more")[1]
      ).to have_link ':edit', href: edit_memo_path(@memo1)
      # 編集ページへ遷移する
      visit edit_memo_path(@memo1)
      # すでに投稿済みの内容がフォームに入っている
      expect(
        find('#memo_text').value
      ).to eq @memo1.text
      expect(
        find('#memo_image').value
      ).to eq @memo1.image
      # 投稿内容を編集する
      fill_in 'memo_text', with: "#{@memo1.text}+編集したテキスト"
      fill_in 'memo_image', with: "#{@memo1.image}+編集した画像URL"
      # 編集してもMemmoモデルのカウントは変わらない
      expect{
        find('input[name="commit"]').click
      }.to change { Memo.count }.by(0)
      # トップページに遷移する
      visit root_path
      # トップページには先ほど変更した内容のメモが存在する（テキスト）
      expect(page).to have_content("#{@memo1.text}+編集したテキスト")
      # トップページには先ほど変更した内容のメモが存在する（画像）
      expect(page).to have_selector ".memo_image[src= url(#{@memo1.image}+編集した画像URL);']"
    end
  end
  context 'メモ編集ができないとき' do
    it 'ログインしたユーザーは自分以外が投稿したメモの編集画面には遷移できない' do
      # メモ1を投稿したユーザーでログインする
      visit new_user_session_path
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      find('input[name="commit"]').click
      expect(current_path).to eq root_path
      # メモ2に「編集」ボタンがない
      expect(
        all(".more")[0]
      ).to have_no_link ':edit', href: edit_memo_path(@memo2)
    end
    it 'ログインしていないとメモの編集画面には遷移できない' do
      # トップページにいる
      visit root_path
      # メモ1に「編集」ボタンがない
      expect(
        all(".more")[1]
      ).to have_no_link ':edit', href: edit_memo_path(@memo1)
      # メモ2に「編集」ボタンがない
      expect(
        all(".more")[0]
      ).to have_no_link ':edit', href: edit_memo_path(@memo2)
    end
  end
end

RSpec.describe 'メモ削除', type: :system do
  before do
    @user = FactoryBot.create(:user)
    @memo1 = FactoryBot.create(:memo)
    @memo2 = FactoryBot.create(:memo)
  end
  context 'メモ削除ができるとき' do
    it 'ログインしたユーザーは自らが投稿したメモの削除ができる' do
      # メモ1を投稿したユーザーでログインする
      visit new_user_session_path
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      find('input[name="commit"]').click
      expect(current_path).to eq root_path
      # メモ1に「削除」ボタンがある
      expect(
        all(".more")[1]
      ).to have_link ':delete', href: memo_path(@memo1)
      # 投稿を削除するとレコードの数が1減る
      expect{
        all(".more")[1].hover.find_link(':delete', href: memo_path(@memo1)).click
      }.to change { Memo.count }.by(-1)
      # トップページに遷移する
      visit root_path
      # トップページにはメモ1の内容が存在しない（テキスト）
      expect(page).to have_no_content("#{@memo1.text}")
      # トップページにはメモ1の内容が存在しない（画像）
      expect(page).to have_no_selector ".memo_image[src= url(#{@memo1.image});']"
    end
  end
  context 'メモ削除ができないとき' do
    it 'ログインしたユーザーは自分以外が投稿したメモの削除ができない' do
      # メモ1を投稿したユーザーでログインする
      visit new_user_session_path
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      find('input[name="commit"]').click
      expect(current_path).to eq root_path
      # メモ2に「削除」ボタンが無い
      expect(
        all(".more")[0]
      ).to have_no_link ':delete', href: memo_path(@memo2)
    end
    it 'ログインしていないとメモの削除ボタンがない' do
      # トップページに移動する
      visit root_path
      # メモ1に「削除」ボタンが無い
      expect(
        all(".more")[1]
      ).to have_no_link ':delete', href: memo_path(@memo1)
      # メモ2に「削除」ボタンが無い
      expect(
        all(".more")[0]
      ).to have_no_link ':delete', href: memo_path(@memo2)
    end
  end
end