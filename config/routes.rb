Rails.application.routes.draw do
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

  root to: 'welcome#index'
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
