class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  
  # def facebook
    # callback_from :facebook
  # end

  # private
  # def callback_from(provider)
    # provider = provider.to_s

    # @user = User.find_for_oauth(request.env['omniauth.auth'])

    # if @user.persisted?
      # flash[:notice] = I18n.t('devise.omniauth_callbacks.success', kind: provider.capitalize)
      # sign_in_and_redirect @user, event: :authentication
    # else
      # session["devise.#{provider}_data"] = request.env['omniauth.auth']
      # redirect_to new_user_registration_url
    # end
  # end
  
  def line
    basic_action
  end

  private

  def basic_action
    @omniauth = request.env["omniauth.auth"]
    if @omniauth.present?
      @profile = User.find_or_initialize_by(provider: @omniauth["provider"], uid: @omniauth["uid"])
      if @profile.email.blank?
        email = @omniauth["info"]["email"] ? @omniauth["info"]["email"] : "#{@omniauth["uid"]}-#{@omniauth["provider"]}@example.com"
        @profile = current_user || User.create!(provider: @omniauth["provider"], uid: @omniauth["uid"], email: email, name: @omniauth["info"]["name"], password: Devise.friendly_token[0, 20])
      end
      @profile.set_values(@omniauth)
      sign_in(:user, @profile)
    end
    # ログイン後のflash messageとリダイレクト先を設定
    flash[:notice] = "ログインしました"
    redirect_to expendable_items_path
  end

  def fake_email(uid, provider)
    "#{auth.uid}-#{auth.provider}@example.com"
  end
end
