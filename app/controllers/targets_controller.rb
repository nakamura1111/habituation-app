class TargetsController < ApplicationController

  def index
    @targets = Target.where(user: current_user).includes(:user)
  end

  def new
    @target = Target.new
  end

  def create
    @target = Target.new(target_params)
    if @target.save
      flash[:success] = "能力値登録完了"
      redirect_to root_path
    else
      flash[:error] = "能力値登録失敗"
      render :new
    end
  end

  def show
    @target = Target.find(params[:id])
    # 習慣の達成状況を表示する日数を設定
    @num_days = 7
    # 達成状況を配列形式に変換
    @achieved_statuses = []
    @target.habits.each do |habit|
      @achieved_statuses << set_achieved_status( @num_days, habit.achieved_or_not_binary)
    end
  end

  private

  def target_params
    point = params[:target][:point]
    point = 0 if point == nil       # 初期値設定
    level, exp = level_and_exp_calc(point)
    params.require(:target).permit(:name, :content).merge(user: current_user, point: point, level: level, exp: exp)
  end

  # 10expでレベルが1上がる設定になっている。(仮設定)
  def level_and_exp_calc(point)
    level = point/10 + 1
    exp = point%10
    return level, exp
  end

  # 二進数データをview表示の形式に置き換える
  def set_achieved_status(num_days, achieved_or_not_binary)
    status = []
    num_days.times do |i|
      # 新しい順に判定する
      if ( ( achieved_or_not_binary >> i ) & 1 ) == 1
        status.push("〇")    # 新しいデータが先頭になるように格納
      else
        status.push("×")
      end
    end
    return status
  end
end
