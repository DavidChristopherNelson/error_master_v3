Rails.application.routes.draw do
  root 'application#home'
  get "bulk_action", 
      to: "deco_errors#update", 
      constraints: { query_string: /routeToDecoErrorUpdate/ }
  get "bulk_action", 
      to: "deco_errors#destroy", 
      constraints: { query_string: /routeToDecoErrorDestroy/ }
  get "bulk_action", 
      to: "application#run_rule_engine", 
      constraints: { query_string: /routeToApplicationRunRuleEngine/ }
  resources :mappings
  resources :rules
  resources :filters
  resources :deco_errors
  resources :folders
end
