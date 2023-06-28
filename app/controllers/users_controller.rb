class UsersController < ApplicationController
  include Commons

  before_action :set_user, only: [:show, :destroy]
  before_action :authenticate_user!, only: [:index, :show, :destroy]
  before_action :admin_user, only: [:index]
  before_action :admin_or_correct_user, only: [:show, :destroy]

  def index
    @users = User.paginate(page: params[:page], per_page: 5)
  end
  
  def show
  end

  def destroy
    if @user
      @user.destroy
      flash[:success] = "#{@user.name}のデータを削除しました。"
      if current_user.admin?
        redirect_to users_url
      else
        redirect_to root_url
      end
    else
      flash[:danger] = "ユーザーが見つかりませんでした。"
      redirect_to(root_url)
    end
  end  

  private
  
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
    
    # ここから下はユーザー専用のbeforeフィルター
    
    # paramsハッシュからユーザーを取得します。
    def set_user
      @user = User.find_by(id: params[:id])
      unless @user
        flash[:danger] = "ユーザーが見つかりませんでした。"
        redirect_to(root_url)
      end
    end
    
end
