Rails.application.routes.draw do
  root 'static_pages#top'

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    omniauth_callbacks: 'omniauth_callbacks'
  }

  resources :users, only: [:index, :show, :destroy] do
    resources :contents do
      resources :sales
    end
  end

  get 'users/:user_id/sales/generate_csv', to: 'sales#generate_csv', as: 'generate_csv_sales'
end
