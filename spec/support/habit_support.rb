module HabitSupport
  def visit_habit_new_action(target)
    # ログインする（トップページに遷移していることを確認済み）
    login_user(target.user)
    # 能力値名をクリックし、目標詳細表示画面へのリンクをクリックする
    find_link(target.name, href: target_path(target)).click
    # 習慣の登録画面の遷移のリンクをクリックする
    find_link('鍛錬内容の登録画面に遷移', href: new_target_habit_path(target)).click
  end
end
