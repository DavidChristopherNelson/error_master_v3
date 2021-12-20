Rails.application.routes.draw do
  resources :mappings
  resources :rules
  resources :filters
  resources :deco_errors
  resources :folders
  root 'application#hello'
end
