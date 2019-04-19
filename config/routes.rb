Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'homepages#index'

  resources :drivers, except: :delete
  resources :passengers, except: :delete
  resources :trips

  resources :passengers do
    resources :trips, only: [:index, :new, :create]
  end

  post '/drivers/:id/available', to: 'drivers#available', as: "driver_availability"
  post '/drivers/:id/destroy', to: 'drivers#destroy', as: "destroy_driver"
  post '/passengers/:id/destroy', to: 'passengers#destroy', as: "destroy_passenger"
end
