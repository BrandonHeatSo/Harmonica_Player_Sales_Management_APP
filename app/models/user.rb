class User < ApplicationRecord
  has_many :contents, dependent: :destroy
  has_many :sales, dependent: :destroy
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable,
         omniauth_providers: %i[line] # LINEログイン用の連携設定を追加。
         # omniauth_providers: [:facebook] # Facebookログイン用の連携設定を追加。
         
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 100 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }, on: :create
  # validates_confirmation_of :password

  # def self.find_for_oauth(auth)
    # user = User.where(uid: auth.uid, provider: auth.provider).first

    # unless user
      # user = User.create(
        # uid:      auth.uid,
        # provider: auth.provider,
        # email:    auth.info.email,
        # name:  auth.info.name,
        # password: Devise.friendly_token[0, 20]
        # , image:  auth.info.image
      # )
    # end

    # user
  # end

  def update_without_current_password(params, *options)
    params.delete(:current_password)

    if params[:password].blank? && params[:password_confirmation].blank? 
      params.delete(:password)
      params.delete(:password_confirmation)
    end

    result = update(params, *options)
    clean_up_passwords
    result
  end

  def social_profile(provider)
    social_profiles.select { |sp| sp.provider == provider.to_s }.first
  end

  def set_values(omniauth)
    return if provider.to_s != omniauth["provider"].to_s || uid != omniauth["uid"]
    credentials = omniauth["credentials"]
    info = omniauth["info"]

    access_token = credentials["refresh_token"]
    access_secret = credentials["secret"]
    credentials = credentials.to_json
    name = info["name"]
  end

  def set_values_by_raw_info(raw_info)
    self.raw_info = raw_info.to_json
    self.save!
  end
  
  def admin?
    admin # adminカラムがtrueの場合を管理者とする
  end

end
