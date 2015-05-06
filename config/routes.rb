Screendoor::Application.routes.draw do
  resources :reservations do
    collection do
      get :all
      post :import
      get :housekeeping
    end
  end
  
  root to: 'reservations#index'
end
