class Users::SessionsController < Devise::SessionsController
  include SessionsHelper
  include Commons
  
  def new
    if user_signed_in?
      flash[:info] = 'すでにログインしています。'
      redirect_to current_user
    else
      super
    end
  end

  def create
    self.resource = warden.authenticate!(:scope => resource_name)
    if resource && resource.save
      sign_in(resource_name, resource)
      flash[:success] = 'ログインしました。'
      redirect_to after_sign_in_path_for(resource)
    else
      flash.now[:danger] = '認証に失敗しました。'
      render :new
    end
  end
  
  def destroy
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    flash[:success] = 'ログアウトしました。' if signed_out
    respond_to_on_destroy
  end

  private

  def after_sign_in_path_for(resource)
    user_path(resource)
  end
end
