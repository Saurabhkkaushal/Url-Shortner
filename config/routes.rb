Rails.application.routes.draw do
  get 'urls/showlongurl' => 'urls#show_long_url'
  get 'urls/longurl' => 'urls#long_url'
  post 'urls/getlongurl' => 'urls#get_long_url'
  get 'dailyreport/index' => 'dailyreport#index'
  get 'urls/error' => 'urls#error'
  get 'urls/search' => 'urls#search'
  post  'urls/getlongurl' => 'urls#get_long_url'
  devise_for :users
  root 'welcome#index'
  require 'sidekiq/web'  
  mount Sidekiq::Web, :at => '/sidekiq' 

  post 'shorten-url' => 'urls#create'

  get 'short-url' => 'urls#get_long_url'
  resources :urls
  
end
