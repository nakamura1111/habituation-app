module UserSupport
  def login_user(user)
    visit new_user_session_path
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: user.password
    find('input[name="commit"]').click
    sleep(1)
    expect(current_path).to eq(root_path)
  end
end