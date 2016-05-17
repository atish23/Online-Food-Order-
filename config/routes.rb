Rails.application.routes.draw do

  mount Ckeditor::Engine => '/ckeditor'
  # resources :carts
  # resources :cart_items

  mount RailsAdmin::Engine => '/admin1', as: 'rails_admin'

  devise_for :users 
  root 'static_pages#home'
  get 'static_pages/about_us', as: :about_us
  get 'static_pages/carriers', as: :carriers
  get 'static_pages/terms', as: :terms
  get 'static_pages/policy', as: :policy
  resources :foods do
    member do
      get :category
    end
  end
  get 'users/:id' => 'users#show' , as: "users_show"
  #delete "carts/:item_id/", to: "carts#destroy", as: :cart_item_delete
  namespace :admin do
    namespace :history do
      resources  :orders, only: [:index, :show] do
        resources  :addresses, only: [:index, :show, :edit, :update, :new, :create]
      end
    end

    namespace :inventory do
      resources :overviews
      resources :adjustments
    end
  end

  namespace :myaccount do
    resources :orders,        only: [:index, :show]
    resources :addresses
    resource  :overview,      only: [:show, :edit, :update]
  end

  namespace :shopping do
    resources :addresses do
      member do 
        put :select_address
      end
    end
    resources :orders do
      member do
        get :checkout
        get :confirmation
      end
    end
    resources  :billing_addresses do
      member do
        put :select_address
      end
    end
     resources  :cart_items do
      member do
        put :move_to
      end
    end
  end

end
