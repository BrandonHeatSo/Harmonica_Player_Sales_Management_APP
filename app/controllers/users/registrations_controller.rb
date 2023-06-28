class Users::RegistrationsController < Devise::RegistrationsController
  include Commons

  before_action :set_user, only: [:edit, :update]
  # before_action :set_user, only: [:edit, :update, :destroy]
  before_action :authenticate_user!, only: [:edit, :update]
  # before_action :authenticate_user!, only: [:edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  # before_action :admin_or_correct_user, only: :destroy
  
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
    super
  end
  
  def update
    super
  end

  # def destroy
    # super
  # end

  protected

    def update_resource(resource, params)
      resource.update_without_current_password(params) # 編集更新時にパスワード入力を任意化
    end

    def after_update_path_for(resource)
      user_path(@user.id) # 更新後のパスをプロフィールに戻るように設定。
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
