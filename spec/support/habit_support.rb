module HabitSupport
  def visit_habit_new_action(target)
    # ログインする（トップページに遷移していることを確認済み）
    login_user(target.user)
    # 能力値名をクリックし、目標詳細表示画面へのリンクをクリックする
    find_link(target.name, href: target_path(target)).click
    # 習慣の登録画面の遷移のリンクをクリックする
    find_link('鍛錬メニューを追加', href: new_target_habit_path(target)).click
  end
  # 目標詳細ページに記載の目標達成状況の表が正しく反映されていることを確認するメソッド
  def confirm_achieved_status(achieved_or_not_binary)
    days = 7
    days.times do |i|
      if ( achieved_or_not_binary>>(days-1-i) & 1 ) == 1
        display = '〇'
      else
        display = '×'
      end
      expect(all('tr.achieved-status-row th')[i]).to have_content(display)
    end
  end
end
