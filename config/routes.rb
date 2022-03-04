require 'sidekiq/web'
Rails.application.routes.draw do

  root 'application#home'
  get 'bulk_action',
      to: 'deco_errors#update',
      constraints: { query_string: /routeToDecoErrorUpdate/ }
  get 'bulk_action',
      to: 'deco_errors#destroy',
      constraints: { query_string: /routeToDecoErrorDestroy/ }
  get 'bulk_action',
      to: 'rules#destroy',
      constraints: { query_string: /routeToRuleDestroy/ }
  resources :rules, :filters, :deco_errors, :folders

  #Background workers
  mount Sidekiq::Web => '/sidekiq'
  get 'workers/status'
  get'/workers/:id', to: 'workers#status'
end
