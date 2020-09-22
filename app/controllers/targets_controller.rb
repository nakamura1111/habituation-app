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
      render 'new'
    end
  end

  def show
    @target = Target.find(params[:id])
  end

  private

  def target_params
    point = params[:target][:point]
    point = 0 if point == nil       # 初期値設定
    level, exp = level_and_exp_calc(point)
    params.require(:target).permit(:name, :content).merge(user: current_user, point: point, level: level, exp: exp)
  end

  # 10expでレベルが1上がる設定になっています。(仮設定)
  def level_and_exp_calc(point)
    level = point/10 + 1
    exp = point%10
    return level, exp
  end
end
