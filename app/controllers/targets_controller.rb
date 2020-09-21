class TargetsController < ApplicationController

  def index
    
  end

  def new
    @target = Target.new
  end

  def create
    @target = Target.new(target_params)
    if @target.save
      flash[:success] = "パラメータ登録完了"
      redirect_to root_path
    else
      flash[:error] = "パラメータ登録失敗"
      render 'new'
    end
  end

  private

  def target_params
    params.require(:target).permit(:name, :content).merge(point: 0, user: current_user)
  end
  
end
