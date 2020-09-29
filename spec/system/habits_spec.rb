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
      fill_in 'habit_name', with: @habit.name
      fill_in 'habit_content', with: @habit.content
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
      fill_in 'habit_name', with: ''
      fill_in 'habit_content', with: ''
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
    @prev_point = 9
    @target.update(point: @prev_point)
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
      expect(@habit.achieved_or_not_binary).to eq(1)
      expect(@habit.achieved_days).to eq(1)
      expect(all('tr.achieved-status-row th')[6]).to have_content('〇')
      # レベル・経験値が反映されていることを確認する
      @target.reload
      expect(@target.point).to eq(@prev_point + @habit.difficulty_grade + 1) # point
      expect(find('.target-level').text).to eq("Lv. #{@target.level} - Level up!")   # level
      expect(find('.exp-bar')[:value].to_i).to eq(@target.exp)                       # exp
    end
  end
end 

RSpec.describe '日付変更による達成状況を変更する機能', type: :system do
  before do
    @habit = FactoryBot.create(:habit)
    @target = @habit.target
    @achieved_or_not_binary = 0b101_0101
    @habit.update(achieved_or_not_binary: @achieved_or_not_binary)
  end
  context '日付変更による達成状況を変更することができるとき' do
    it '24:00に達成状況が変更される' do
      # ログインして、目標の詳細ページに遷移
      visit_target_show_action(@target)
      # 目標達成状況が正しく出力されていることを確認する
      confirm_achieved_status(@habit.achieved_or_not_binary)
      # 日付を跨ぐ
      time_now = Time.now
      travel_to Time.zone.local(time_now.year, time_now.mon, time_now.day+1, 0, 0, 1) do
        # 目標達成状況が正しく反映されていることを確認する
        @habit.reload
        visit target_path(@target)
        confirm_achieved_status(@habit.achieved_or_not_binary)
      end
    end
  end
end