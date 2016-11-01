Rails.application.routes.draw do
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

  get 'companys/show'

  get 'companys/index'

  get 'clients/new'

  get 'clients/index'

  get 'clients/show'

post 'companys/show'
post 'mpoints/show'

resources :companys 
resources :mpoints  do
  resources :mvalues
end
resources :mpoints  do  
  resources :trparams
end

resources :mpoints  do  
  resources :lineprs
end    

  root to: 'welcome#index'
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
