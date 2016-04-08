Rails.application.routes.draw do

  mount Ckeditor::Engine => '/ckeditor'
  resources :carts
  resources :cart_items

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  devise_for :users 
  root 'static_pages#home'
  get 'static_pages/about_us', as: :about_us
  get 'orders/checkout', as: :checkout
  resources :foods
  get 'users/:id' => 'users#show' , as: "users_show"
  delete "carts/:item_id/", to: "carts#destroy", as: :cart_item_delete
end
