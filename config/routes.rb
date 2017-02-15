Rails.application.routes.draw do
  get 'meters/index'
  post '/meters/index' => 'meters#index'
  get 'meters/update'
  get 'meters/show'
  post '/meters/show' => 'meters#show'
  get 'meters/destroy'
  get 'meters/edit'

  get 'static_pages/home'
  get 'static_pages/help'

  root 'welcome#index'
    
  get 'filials/index'
  get 'filials/show'
  get 'filials/edit'
  get 'filials/new'

  get 'furnizors/show'
  get 'furnizors/new'
  get 'furnizors/index'
  get 'furnizors/edit'

  get 'trparams/create'
  get 'trparams/update'
  get 'trparams/destroy'
  get 'trparams/edit'
  post '/trparams/:id/edit' => 'trparams#edit'

  get 'lnparams/create'
  get 'lnparams/new'
  get 'lnparams/edit'
  get 'lnparams/destroy'

  get 'welcome/cdindex'
  get 'welcome/setsuindex'
  
  get 'mvalues/new'
  get 'mvalues/edit'
  get 'mvalues/show'
  get 'mvalues/index'
  get 'mvalues/destroy'

  get 'mpoints/new'
  get 'mpoints/show'
  post '/mpoints/show' => 'mpoints#show'
  post '/mpoints/:id' => 'mpoints#show'
  get 'mpoints/index'
  get 'mpoints/edit'

  get 'companies/new'
  post 'companies/new'
  get 'companies/index'
  get '/companies/report' => 'companies#report'
  post '/companies/report' => 'companies#report'
  get '/companies/show' => 'companies#show'
  post '/companies/show' => 'companies#show'  

  get 'clients/new'
  get 'clients/index'
  get 'clients/show'

resources :filials
resources :furnizors

resources :companies  do
  resources :mpoints
end

resources :mpoints  do
  resources :meters
end

resources :meters do
    resources :mvalues
end

resources :mpoints  do
    resources :mvalues
end

resources :mpoints  do  
  resources :trparams
end

resources :mpoints  do  
  resources :lnparams
end    

  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
