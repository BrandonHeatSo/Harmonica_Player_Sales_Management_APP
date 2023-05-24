Rails.application.routes.draw do
  root 'static_pages#top'

  devise_for :users, controllers: {
    omniauth_callbacks: "omniauth_callbacks"
  }
end
