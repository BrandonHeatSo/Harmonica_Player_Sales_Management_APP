Rails.application.routes.draw do
  root 'static_pages#top'

  devise_for :users, controllers: {
    omniauth_callbacks: "omniauth_callbacks",
    registrations: 'users/registrations'
  }

  get 'users', to: 'users/registrations#index' # ユーザーindexアクションの生成
  get 'users/:id', to: 'users/registrations#show' # ユーザーshowアクションの生成

end
