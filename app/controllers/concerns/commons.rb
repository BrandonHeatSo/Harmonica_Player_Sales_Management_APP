module Commons
  include SessionsHelper
  
  # beforeフィルター

  # paramsハッシュからユーザーを取得します。
  def set_user
    @user = User.find(params[:id])
  end

  # ログイン済みのユーザーか確認します。
  # def logged_in_user
    # unless user_signed_in?
      # flash[:danger] = 'ログインしてください。'
      # redirect_to root_url
    # end
  # end

  # アクセスしたユーザーが現在ログインしているユーザーか確認します。
  def correct_user
    unless current_user == @user
      flash[:danger] = "本人アカウントでログインしてください。"
      redirect_to(root_url)
    end
  end

  # システム管理権限所有かどうか判定します。
  def admin_user
    unless current_user.admin?
      flash[:danger] = "システム管理権限がありません。"
      redirect_to root_url
    end
  end

  # 管理権限者、または現在ログインしているユーザー本人を許可します。
  def admin_or_correct_user
    unless current_user == @user || current_user.admin?
      flash[:danger] = "権限がありません。"
      redirect_to(root_url)
    end
  end
end
