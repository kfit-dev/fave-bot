Rails.application.routes.draw do
  
  resources :payload, only: [:create, :index]
end
