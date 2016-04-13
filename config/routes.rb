Rails.application.routes.draw do

  mount Ckeditor::Engine => '/ckeditor'
  resources :carts
  resources :cart_items

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  devise_for :users 
  root 'static_pages#home'
  get 'static_pages/about_us', as: :about_us
  resources :foods
  get 'users/:id' => 'users#show' , as: "users_show"
  delete "carts/:item_id/", to: "carts#destroy", as: :cart_item_delete


  namespace :myaccount do
    resources :orders,        only: [:index, :show]
    resources :addresses
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
  end

end
