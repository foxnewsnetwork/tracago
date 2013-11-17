Tracago::Application.routes.draw do

  root :to => 'home#index'

  resources :users, only: [:show], controller: 'spree/users' do
    resources :preferences, only: [:index], controller: 'spree/users/preferences'
  end

  devise_scope :users do
    get '/login' => 'spree/users/sessions#new', :as => :login
    get '/signup' => 'spree/users/registrations#new', :as => :signup
    get '/password/recover' => 'spree/users/passwords#new', :as => :recover_password
    get '/password/change' => 'spree/users/passwords#edit', :as => :edit_password
  end

  devise_for :users,
    class_name: 'Spree::User',
    controllers: {
      sessions: 'spree/users/devise/sessions',
      registrations: 'spree/users/devise/registrations',
      passwords: 'spree/users/devise/passwords'
    }
  
  resources :finalizations, only: [:show], controller: 'spree/finalizations' do
    resources :truck_demands, 
      only: [:new, :create], 
      controller: 'spree/finalizations/serviceables/trucks'
    resources :ship_demands, 
      only: [:new, :create], 
      controller: 'spree/finalizations/serviceables/ships'
    resources :post_transactions, 
      only: [:new, :create], 
      controller: 'spree/finalizations/post_transactions'
  end
  resources :post_transactions, only: [:show], controller: 'spree/post_transactions' do
    resources :dispute_negotiations, 
      only: [:index, :create, :new], 
      controller: 'spree/post_transactions/dispute_negotiations'
  end
  resources :demands, only: [:show], controller: 'spree/demands'
  resources :stockpiles, controller: 'spree/stockpiles' do
    member do
      get :edit_address
      get :edit_picture
      get :edit_seller_offer
    end
    resources :addresses, 
      only: [:new, :create], 
      controller: 'spree/stockpiles/addresses'
  end
  resources :listings, controller: 'spree/listings' do
    resources :shops, 
      only: [:new, :create], 
      controller: 'spree/listings/shops'
    resources :offers, 
      only: [:create, :index], 
      controller: 'spree/listings/offers'
    resources :stockpiles, 
      only: [:new, :create], 
      controller: 'spree/listings/stockpiles'
  end
  resources :offers, only: [:show, :edit, :update, :destroy], controller: 'spree/offers' do
    resources :finalizations, 
      only: [:new, :create],
      controller: 'spree/offers/finalizations'
    member do
      get :counter
    end
    resources :comments, only: [:new, :create], controller: 'spree/offers/comments' do
      collection do
        get :demand
      end
    end
    resources :addresses, only: [:create, :new], controller: 'spree/offers/addresses'
  end
  resources :shops, only: [:show], controller: 'spree/shops' do
    resources :ratings, only: [:index], controller: 'spree/shops/ratings'
    resources :listings, only: [:index], controller: 'spree/shops/listings'
    resources :offers, only: [:index], controller: 'spree/shops/offers'
    resources :finalizations, only: [:index], controller: 'spree/shops/finalizations'
    resources :serviceables, only: [:index], controller: 'spree/shops/serviceables'
    resources :post_transactions, only: [:index], controller: 'spree/shops/post_transactions'
  end
  resources :ratings, only: [:show], controller: 'spree/ratings'
          # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end
  
  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
