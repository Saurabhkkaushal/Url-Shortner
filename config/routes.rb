Rails.application.routes.draw do
  get 'urls/showlongurl' => 'urls#showlongurl'
  get 'urls/longurl' => 'urls#longurl'
  post 'urls/getlongurl' => 'urls#getlongurl'
  get 'dailyreport/index' => 'dailyreport#index'
  get 'urls/error' => 'urls#error'
  get 'urls/search' => 'urls#search'
  #post 'urls/longurl' => 'urls#getlongurl'
  post  'urls/getlongurl' => 'urls#getlongurl'
  devise_for :users
  root 'welcome#index'
  require 'sidekiq/web'  
  mount Sidekiq::Web, :at => '/sidekiq' 

  post 'shorten-url' => 'urls#create'

  get 'short-url' => 'urls#getlongurl'
  resources :urls
  

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
