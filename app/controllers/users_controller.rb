class UsersController < ApplicationController
  include Commons

  before_action :set_user, only: [:show]
  before_action :authenticate_user!, only: [:index, :show]
  before_action :correct_user, only: [:show]
  before_action :admin_user, only: [:index]

  def index
    @users = User.paginate(page: params[:page], per_page: 5)
  end
  
  def show
  end

  private
  
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
    
    # ここから下はユーザー専用のbeforeフィルター
    
    # paramsハッシュからユーザーを取得します。
    def set_user
      @user = User.find(params[:id])
    end
end
