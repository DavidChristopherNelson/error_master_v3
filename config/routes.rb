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
  resources :mappings, :rules, :filters, :deco_errors, :folders
end
