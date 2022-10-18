Rails.application.routes.draw do
  
  root to: "companies#root"
  #get 'search', to: 'companies#index'

  # super admin (user) with role super_admin
  resource :super_admin, except: [:new, :create, :destroy] do
    resources :companies do
      resources :users # company admins
      resources :employees
    end
    resources :users # internal admins
    
    
  end

  # internal admins (user), with role admin and without company_id
  resources :admins, except: [:new, :create, :destroy] do
    resources :companies do
      resources :employees
      resources :users
    end
  end

  # company admins (user), with role admin and with company_id
  resources :company_admins, except: [:new, :create, :destroy] do
    resource :company, except: [:new, :create, :destroy] do
      resources :employees
      resources :users
    end
  end



  
  devise_for :users
  get 'user/index'
  get 'user/new'
  get 'user/show'

  resources :companies do
    resources :employees do
    end
    collection do 
      get :home
      get :service
      get :indexx
      get :profile
    end
   
  end

end
