module SessionsHelper

  # Deviseのログインメソッドを使用してユーザーをログインさせる
  def log_in(user)
    sign_in(user)
  end

  # Deviseのログアウトメソッドを使用してユーザーをログアウトさせる
  def log_out
    sign_out(current_user)
  end

  # Deviseのメソッドを使用して現在のユーザーを取得する
  def current_user
    current_user
  end

  # ユーザーがログインしていればtrue、そうでなければfalseを返す
  def logged_in?
    user_signed_in?
  end
end
