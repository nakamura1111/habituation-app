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

  def update_achieved_status
    @habit = Habit.find(params[:habit_id])
    if update_transaction(@habit)
      flash[:success] = "更新しました"
      ActionCable.server.broadcast 'habits_achieved_status', content: @habit
    else
      flash[:error] = "更新できませんでした"
      render :index
    end
  end
  
  private

  def habit_params
    params.require(:habit).permit(:name, :content, :difficulty_grade).merge(target: @target, achieved_or_not_binary: 0, achieved_days: 0, is_active: true)
  end

  def current_target
    @target = Target.find(params[:target_id])
  end

  def update_transaction(habit)
    ActiveRecord::Base.transaction do
      is_add = habit.achieved_or_not_binary&1       # Targetのpointが増えるかどうかを判定
      habit.update(achieved_or_not_binary: habit.achieved_or_not_binary | 1 )
      add_target_point(habit, is_add)
      return true
    end
  end

  def add_target_point(habit, is_add)
    if is_add
      point = habit.target.point + habit.difficulty_grade + 1
      habit.target.update(point: point)
    end
    return true
  end
end
