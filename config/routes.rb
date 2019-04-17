Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'homepages#index'

  resources :drivers
  resources :trips
  resources :passengers

  resources :passengers do
    resources :trips, only: [:index, :new, :create]
  end

  post '/drivers/:id/available', to: 'drivers#available', as: "driver_availability"
end
