class UsersController < ApplicationController
  # deviseのルーティングエラーを解消するため、deviseとは別に作成されたコントローラです。
  def retake_registration
    redirect_to new_user_registration_path
  end
end
