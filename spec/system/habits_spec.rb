require 'rails_helper'

RSpec.describe '習慣の登録機能', type: :system do
  before do
    @habit = FactoryBot.build(:habit)
    @habit.target.save
  end
  context '達成目標が登録できるとき' do
    it '達成目標とその能力値名を入力したとき、登録される' do
      # ログインして、習慣登録ページに遷移
      visit_habit_new_action(@habit.target)
      # 達成目標の登録フォームに入力する
      fill_in '鍛錬の内容', with: @habit.name
      fill_in '鍛錬の詳細な内容', with: @habit.content
      select Difficulty.find(@habit.difficulty_grade).name, from: 'habit[difficulty_grade]'
      # 登録ボタンを押すと、出品情報がDBに登録されることを確認する
      expect do
        find('input[name="commit"]').click
      end.to change { Habit.count }.by(1)
      # 目標詳細表示画面に遷移していることを確認する
      expect(current_path).to eq(target_path(@habit.target))
    end
  end
  context '達成目標が登録できないとき' do
    it '未ログインユーザは達成目標の登録画面に遷移できない' do
      # 習慣の登録画面へ遷移する
      visit new_target_habit_path(@habit.target)
      # ログインページであることを確認する
      expect(current_path).to eq(new_user_session_path)
    end
    it '入力内容が空の場合、登録できない' do
      # ログインして、習慣登録ページに遷移
      visit_habit_new_action(@habit.target)
      # 達成目標の登録フォームの入力
      fill_in '鍛錬の内容', with: ''
      fill_in '鍛錬の詳細な内容', with: ''
      # 登録ボタンを押しても、出品情報がDBに登録されていないことを確認する
      expect do
        find('input[name="commit"]').click
      end.to change { Habit.count }.by(0)
      # 習慣の登録画面に遷移していることを確認する
      expect(current_path).to eq(target_habits_path(@habit.target))
    end
  end
end
