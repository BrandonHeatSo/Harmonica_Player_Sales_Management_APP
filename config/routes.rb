Rails.application.routes.draw do
  root 'static_pages#top'

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    # omniauth_callbacks: 'omniauth_callbacks'
    omniauth_callbacks: "users/omniauth_callbacks"
  }

  resources :users, only: [:index, :show, :destroy] do
    resources :contents do
      resources :sales
    end
  end
end
