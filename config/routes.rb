Auctioneer::Application.routes.draw do

  resources :auctions do
		resources :mailing_list, only: [:create, :destroy]		
	  resources :bids
  end

  resources :users

  root to: 'static_pages#home'
  match "/about", to: "static_pages#about"
  match "/contact", to: "static_pages#contact"

  match '/forgot', to: "users#forgot"
  match '/reset/:reset_code' => "users#reset", :via => [:get, :put], as: :reset 

	resources :sessions, only: [:new, :create, :destroy]
  match '/signin',  to: 'sessions#new'
  match '/signout', to: 'sessions#destroy', via: :delete	
end
