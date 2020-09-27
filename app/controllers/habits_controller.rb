class HabitsController < ApplicationController
  before_action :current_target, only: [:new, :create]

  def new
    @habit = Habit.new
  end
  
  def create
    @habit = Habit.new(habit_params)
    if @habit.save
      flash[:success] = "鍛錬内容の登録完了"
      redirect_to target_path(@habit.target)
    else
      flash[:error] = "鍛錬内容の登録失敗"
      render 'new'
    end
  end
  
  private

  def habit_params
    params.require(:habit).permit(:name, :content, :difficulty_grade).merge(target: @target, achieved_or_not_binary: 0, achieved_days: 0, is_active: true)
  end

  def current_target
    @target = Target.find(params[:target_id])
  end
end
