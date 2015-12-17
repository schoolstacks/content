Rails.application.routes.draw do
  resources :document_exports, except: [:edit, :update] do
    get :download, on: :member
  end
  
  resources :document_imports, except: [:edit, :update] do
    post :publish, on: :member
  end

  devise_for :users

  authenticated :user do
    root 'welcome#index'
  end

  root 'visitor/welcome#index', as: :visitor_root
end
