class Users::SessionsController < Devise::SessionsController
  include SessionsHelper
  
  def new
    if logged_in?
      flash[:info] = 'すでにログインしています。'
      redirect_to current_user
    else
      super
    end
  end

  # def create
    # self.resource = warden.authenticate(auth_options)
  
    # if resource.save
      # sign_in(resource_name, resource)
      # flash[:success] = 'ログインしました。'
      # redirect_to after_sign_in_path_for(resource)
    # else
      # flash.now[:danger] = '認証に失敗しました。'
      # render :new
    # end
  # end  

  def create
    puts "=== Debug Start ===" # アクション用デバッグ記述1（エラー解決後は外す予定）
    puts "auth_options: #{auth_options.inspect}" # アクション用デバッグ記述2（エラー解決後は外す予定）
    self.resource = warden.authenticate!(:scope => resource_name)
    puts "resource: #{resource.inspect}" # アクション用デバッグ記述3（エラー解決後は外す予定）
  
    if resource && resource.save
      sign_in(resource_name, resource)
      flash[:success] = 'ログインしました。'
      redirect_to after_sign_in_path_for(resource)
    else
      flash.now[:danger] = '認証に失敗しました。'
      render :new
    end
  
    puts "=== Debug End ===" # アクション用デバッグ記述4（エラー解決後は外す予定）
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
