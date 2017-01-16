Rails.application.routes.draw do
  get 'meters/index'
  post '/meters/index' => 'meters#index'
 
  get 'meters/update'

  get 'meters/show'

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

  get 'trparams/new'

  get 'trparams/show'

  get 'trparams/index'

  get 'trparams/edit'

  get 'lineprs/new'

  get 'lineprs/show'

  get 'lineprs/index'

  get 'lineprs/edit'

  get 'welcome/cdindex'
  get 'welcome/setsuindex'
  
  get 'mvalues/new'

  get 'mvalues/edit'

  get 'mvalues/show'

  get 'mvalues/index'

  get 'mpoints/new'

  get 'mpoints/show'

  get 'mpoints/index'

  get 'mpoints/edit'

  get 'companys/new'
  post 'companys/new'

  get 'companys/index'

  get 'clients/new'

  get 'clients/index'

  get 'clients/show'

get '/companys/report' => 'companys#report'
post '/companys/report' => 'companys#report'
get '/companys/show' => 'companys#show'
post '/companys/show' => 'companys#show'
post 'mpoints/show'
post 'trparams/:id/edit' => 'trparams#edit'

resources :filials
resources :trparams
resources :furnizors
resources :companys 
resources :mpoints  do
  resources :mvalues
end
resources :mpoints  do
  resources :meters
end
resources :mpoints  do  
  resources :trparams
end

resources :mpoints  do  
  resources :lineprs
end    

  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
