class Users::RegistrationsController < Devise::RegistrationsController
  include Commons

  before_action :set_user, only: [:edit, :update, :destroy]
  before_action :authenticate_user!, only: [:edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy]
  before_action :admin_or_correct_user, only: :destroy
  
  def new
    if user_signed_in? && !current_user.admin?
      flash[:info] = 'すでにログインしています。'
      redirect_to user_url(current_user)
    end
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      flash[:success] = 'ユーザーの新規作成に成功しました。'
      redirect_to user_url(@user)
    else
      render :new
    end
  end
  
  def edit
  end
  
  def update
    if  @user.update_attributes(user_params)
      flash[:success] = "ユーザー情報を更新しました。"
      redirect_to user_url(@user)
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    flash[:success] = "#{@user.name}のデータを削除しました。"
    redirect_to users_url
  end

  private
  
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
    
    # ここから下はユーザーＣ専用のbeforeフィルター
    
    # paramsハッシュからユーザーを取得します。
    def set_user
      @user = current_user
    end
end
