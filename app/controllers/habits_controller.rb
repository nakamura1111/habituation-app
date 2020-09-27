# 習慣に関する機能を実装するためのコントローラー
class HabitsController < ApplicationController
  before_action :current_target, only: %i[new create]

  def new
    @habit = Habit.new
  end

  def create
    @habit = Habit.new(habit_params)
    if @habit.save
      flash[:success] = '鍛錬内容の登録完了'
      redirect_to target_path(@habit.target)
    else
      flash[:error] = '鍛錬内容の登録失敗'
      render 'new'
    end
  end

  def update_achieved_status
    @habit = Habit.find(params[:habit_id])
    if update_transaction(@habit)
      @habit.reload
      flash[:success] = '更新しました'
      ActionCable.server.broadcast 'habits_achieved_status_channel', content: @habit
      ActionCable.server.broadcast 'targets_achieved_status_channel', content: @habit.target
    else
      flash[:error] = '更新できませんでした'
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
      is_add = habit.achieved_or_not_binary & 1 # Targetのpointが増えるかどうかを判定
      habit.update(achieved_or_not_binary: habit.achieved_or_not_binary | 1, achieved_days: habit.achieved_days + 1)
      add_target_point(habit, is_add)
      return true
    end
  end

  # Targetモデルに移動させたい
  def add_target_point(habit, is_add)
    if is_add
      point = habit.target.point + habit.difficulty_grade + 1
      level, exp = level_and_exp_calc(point)
      habit.target.update(point: point, level: level, exp: exp)
    end
    true
  end

  # 10expでレベルが1上がる設定になっている。(仮設定)
  # 被っているので、モデルに移動させる
  def level_and_exp_calc(point)
    level = point / 10 + 1
    exp = point % 10
    [level, exp]
  end
end
