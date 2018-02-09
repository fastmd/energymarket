Rails.application.routes.draw do
  get 'application/home'
  
  get 'meters/index'
  post 'meters/index'
  get 'meters/update'
  get 'meters/show'
  post 'meters/show'
  get 'meters/destroy'
  get 'meters/edit'
  get 'meters/helpcounter'

  get 'static_pages/home'
  get 'static_pages/help'

  root 'welcome#index'


  get 'minputs/index'
  post 'minputs/index'
  get 'minputs/edit'
  post 'minputs/edit'
  get 'minputs/destroy'
  post 'minputs/destroy' 
  resources :minputs do
  end  


  get 'trparams/create'
  get 'trparams/update'
  get 'trparams/destroy'
  get 'trparams/edit'
  resources :trparams do
  end
  
  get 'transformators/show' => 'transformators/index'
  get 'transformators/index'
  get 'transformators/edit'
  get 'transformators/destroy'
  resources :transformators do
  end

  get 'lnparams/create'
  get 'lnparams/new'
  get 'lnparams/edit'
  get 'lnparams/destroy'
  resources :lnparams do
  end
  
  get 'lines/index'
  get 'lines/edit'
  get 'lines/destroy'
  resources :lines do
  end 
  
  get 'wires/index'
  get 'wires/edit'
  get 'wires/destroy'
  resources :wires do
  end 
  
  get 'welcome/index'
  get 'welcome/help'
  get 'welcome/counter'
  get 'welcome/mvalue'
  get 'welcome/mpoint'
  get 'welcome/thesaurus'  
  
  get 'thesaurus/index'
  post 'thesaurus/index'
  get 'thesaurus/edit'
  post 'thesaurus/edit'
  get 'thesaurus/update'
  get 'thesaurus/destroy'
  
  resources :thesaurus do
  end
  
  get  'mesubstations/index'
  post 'mesubstations/index'
  get  'mesubstations/edit'
  post 'mesubstations/edit'
  get  'mesubstations/update'
  get  'mesubstations/destroy'
  
  resources :mesubstations do
  end
  
  get 'mvalues/new'
  get 'mvalues/edit'
  get 'mvalues/show'
  get 'mvalues/index'
  get 'mvalues/destroy'

  get 'mpoints/new'
  get 'mpoints/show'
  post 'mpoints/show'
  get 'mpoints/showmvalues'  
  get 'mpoints/index'
  get 'mpoints/search' => 'mpoints/index'
  post 'mpoints/search' => 'mpoints/index'
  get 'mpoints/edit'
  get 'mpoints/destroy'
  get 'mpoints/update'
  get 'mpoints/helpmvalue'
  
  get 'companies/index'
  get 'companies/all' 
  get 'companies/update'
  get 'companies/destroy'
  get 'companies/edit'
  get 'companies/simplereports'
  post 'companies/simplereports'
  get 'companies/regionreports'
  post 'companies/regionreports'
  get 'companies/graphreports'
  post 'companies/graphreports'
  get 'companies/reports'
  post 'companies/reports'
  get 'companies/report'
  post 'companies/report'
  get 'companies/mvreport' => 'companies#mvreport'
  get 'companies/mtreport'
  get 'companies/paramreport'
  get 'companies/onempreport'
  post 'companies/onempreport'
  get 'companies/show'
  post 'companies/show'
  get 'companies/helpmpoint'

resources :filials  do
  resources :mesubstations
end

resources :furnizors  do
  resources :mpoints
end

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

resources :trparams  do  
  resources :transformators
end

resources :mpoints  do  
  resources :lnparams
end

resources :lnparams  do  
  resources :lines
end    

resources :lines  do  
  resources :wires
end 

resources :mpoints  do
    resources :minputs
end

  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
