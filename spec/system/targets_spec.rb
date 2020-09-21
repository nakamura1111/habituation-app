require 'rails_helper'

RSpec.describe '達成目標登録機能', type: :system do
  before do
    @target = FactoryBot.build(:target)
    @target.user.save
  end
  context '達成目標が登録できるとき' do
    it '達成目標とその能力値名を入力したとき、登録される' do
      # ログインする（トップページに遷移していることを確認済み）
      login_user(@target.user)
      # 達成目標登録画面へ遷移する
      find_link('パラメータ設定画面へ遷移', href: new_target_path).click
      # 達成目標の登録フォームに入力する
      fill_in '達成目標', with: @target.content
      fill_in '能力値名', with: @target.name
      # 登録ボタンを押すと、出品情報がDBに登録されることを確認する
      expect do
        find('input[name="commit"]').click
      end.to change { Target.count }.by(1)
      # トップページに遷移していることを確認する
      expect(current_path).to eq(root_path)
    end
  end
  context '達成目標が登録できないとき' do
    it '未ログインユーザは達成目標の登録画面に遷移できない' do
      # トップページに遷移する
      visit root_path
      # ログインページであることを確認する
      expect(current_path).to eq(new_user_session_path)
      # 達成目標登録画面へ遷移する
      visit new_target_path
      # ログインページであることを確認する
      expect(current_path).to eq(new_user_session_path)
    end
    it '入力内容が空の場合、登録できない' do
      # ログインする（トップページに遷移していることを確認済み）
      login_user(@target.user)
      # 達成目標登録画面へ遷移する
      find_link('パラメータ設定画面へ遷移', href: new_target_path).click
      # 達成目標の登録フォームの入力
      fill_in '達成目標', with: ''
      fill_in '能力値名', with: ''
      # 登録ボタンを押しても、出品情報がDBに登録されていないことを確認する
      expect do
        find('input[name="commit"]').click
      end.to change { Target.count }.by(0)
      # 達成目標の登録画面に遷移していることを確認する
      expect(current_path).to eq(targets_path)
    end
  end
end
