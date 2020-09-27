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

RSpec.describe '習慣の達成チェック機能', type: :system do
  before do
    @habit = FactoryBot.create(:habit)
    @target = @habit.target
  end
  context '習慣達成の記録ができるとき' do
    it '達成状況のクリックすると登録される' do
      # ログインして、目標の詳細ページに遷移
      visit_target_show_action(@target)
      # 今日の日付のクリックして、達成状況を更新する
      find("#achieved-check-cell-#{@habit.id}").click_link('達成したらチェック')
      # 目標詳細表示画面に遷移していることを確認する
      expect(current_path).to eq(target_path(@target))
      # 達成状況が反映されていることを確認する
      @habit.reload
      expect(all("tr.achieved-status-row th")[6]).to have_content("〇")
      expect(@habit.achieved_or_not_binary).to eq(1)
      expect(@habit.achieved_days).to eq(1)
      expect().to eq('レベルの反映忘れずに')
    end
  end
end