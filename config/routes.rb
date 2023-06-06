Rails.application.routes.draw do
  root 'static_pages#top'

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  get 'users', to: 'users/registrations#index' # ユーザーindexアクションの生成
  get 'users/:id', to: 'users/registrations#show' # ユーザーshowアクションの生成

end
