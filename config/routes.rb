Tracago::Application.routes.draw do

  root :to => 'spree/home#index'
  namespace 'itps' do
    get '/' => 'home#index'
    get '/faq' => 'home#faq'
    get '/usage' => 'home#usage'
    get '/account' => 'home#account'
    get '/help' => 'home#help'
    get '/aboutus' => 'home#aboutus'
    get '/terms' => 'home#terms'
    get '/legal' => 'home#legal'
    get '/status' => 'home#status'
    get '/blog' => 'home#blog'
    get '/jobs' => 'home#jobs'
    get '/documentation' => 'home#documentation'
    resources :doc_tags, only: [:show]
    resources :steps, only: [:show, :edit] do
      member do
        put :swap_down
        put :swap_up
        post :approve
      end
      resources :documents, only: [:new, :create], controller: 'steps/documents'
    end
    resources :documents, only: [:show]
    resources :escrows do
      resources :steps, only: [:new, :create], controller: 'escrows/steps'
    end
    devise_for :accounts,
      class_name: 'Itps::Account',
      controllers: {
        sessions: 'itps/accounts/sessions',
        registrations: 'itps/accounts/registrations',
        passwords: 'itps/accounts/passwords'
      }
  end

  resources :searches, only: [:index]
  resources :services, only: [:index]
  resources :service_demands, only: [:show]
  resources :service_supplies, only: [:show]

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
  
  resources :escrow_steps, only: [:show, :update], controller: 'spree/escrow_steps'

  resources :escrows, only: [:show, :edit], controller: 'spree/escrows' do
    member do
      get :close
    end
  end
  resources :finalizations, only: [:edit, :show], controller: 'spree/finalizations' do
    resources :ratings,
      only: [:new, :create],
      controller: 'spree/finalizations/ratings'
    resources :comments,
      only: [:new, :create],
      controller: 'spree/finalizations/comments'
    resources :escrows,
      only: [:new, :create],
      controller: 'spree/finalizations/escrows'
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
      only: [:create, :index, :new], 
      controller: 'spree/listings/offers'
    resources :stockpiles, 
      only: [:new, :create], 
      controller: 'spree/listings/stockpiles'
  end
  resources :offers, only: [:show, :edit, :update, :destroy], controller: 'spree/offers' do
    member do
      get :confirmation
      post :confirm
    end
    resources :counter_offers, only: [:new], controller: 'spree/counter_offers'
    resources :services, only: [:new], controller: 'spree/offers/services'
    resources :finalizations, 
      only: [:new, :create, :index],
      controller: 'spree/offers/finalizations'
    resources :comments, only: [:new, :create], controller: 'spree/offers/comments'
    resources :addresses, only: [:create, :new], controller: 'spree/offers/addresses'
  end
  resources :shops, only: [:show, :edit], controller: 'spree/shops' do
    resources :ratings, only: [:index], controller: 'spree/shops/ratings' do
      collection do
        get :given
      end
    end
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
