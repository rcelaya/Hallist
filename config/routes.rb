Hadean::Application.routes.draw do

  get "contacts/index"

  resources :user_sessions, :only => [:new, :create, :destroy]

  match 'admin'   => 'admin/overviews#index'
  match 'login'   => 'user_sessions#new'
  match 'logout'  => 'user_sessions#destroy'
  match 'signup'  => 'customer/registrations#new'
  match 'admin/merchandise' => 'admin/merchandise/summary#index'

  get 'about', to: 'statics#about'
  get 'privacy', to: 'statics#privacy'
  get 'terms', to: 'statics#terms'
  get 'contact', to: 'statics#contact'
  post 'send_inquiry', to: 'statics#send_inquiry'

  match 'browse' => 'products#index', as: 'browse'
  match 'category/:product_type_id' => 'products#index', as: 'browse_category'
  match 'color/:property_values_id' => 'products#index', as: 'browse_color'
  match 'price/:price_from' => 'products#index', as: 'browse_price_from'
  match 'price/:price_from/:price_to' => 'products#index', as: 'browse_price_from_to'
  match 'search' => 'products#index', as: 'search'
  match 'search/:search_term' => 'products#index', as: 'search_term'
  
  match 'hallists/search' => 'hallists#index', as: 'hallists_search'
  match 'hallists/search/:search_term' => 'hallists#index', as: 'hallists_search_term'
  
  match 'artists/search' => 'artists#index', as: 'artists_search'
  match 'artists/search/:search_term' => 'artists#index', as: 'artists_search_term'

  resources :authentications
  match '/auth/:provider/callback' => 'authentications#create'
  
  resources :comments
  resources :bids, only: [:create]
  
  resources :products, :only => [:index, :show, :create] do
    resources :collection_cart_items, only: [:create, :destroy]
    resource :likes, only: [:create, :destroy], controller: 'products/likes'
  end

  resources :artists, only: [:index] do
    resource :follows, only: [:create, :destroy]
  end

  resources :collections,  :only => [:destroy, :create, :update, :show]
  resources :hallists,  :only => [:index, :destroy, :create, :update, :show]
  resources :states,      :only => [:index]
  resource :about,        :only => [:show]

  root :to => "products#index"

  namespace :customer do
    resources :registrations,   :only => [:new, :create]
    resource  :password_reset,  :only => [:new, :create, :edit, :update]
    resource  :activation,      :only => [:show]
  end

  namespace :myaccount do
    resources :orders, :only => [:index, :show]
    resources :addresses
    resources :credit_cards
    resource  :store_credit, :only => [:show]
    resource  :overview, :only => [:show, :edit, :update]
  end

  namespace :artwork do
    resource :dashboard, only: :show, controller: 'dashboard'
    resources :products do
      resources :variants, only: :destroy
    end
  end

  namespace :shopping do
    resource :paypal_checkout, controller: :paypal_checkout do
      member do
        get :review
      end
    end

    resource :creditcard_checkout, controller: :creditcard_checkout do
      member do
        post :pay
      end
    end

    resources  :cart_items do
      member do
        put :move_to
      end
    end
    resource  :coupon, :only => [:show, :create]
    resources  :orders do
      member do
        get :checkout
      end
    end
    resource :checkout, controller: :checkout, only: [:show, :update] do
      member do
        post :twocheckout_return
      end
    end
    resources  :shipping_methods
    resources  :addresses do
      member do
        put :select_address
      end
    end

  end

  namespace :admin do
    resources :users
    resources :overviews, :only => [:index]

    match "help" => "help#index"

    namespace :rma do
      resources  :orders do
        resources  :return_authorizations do
          member do
            put :complete
          end
        end
      end
      #resources  :shipments
    end

    namespace :history do
      resources  :orders, :only => [:index, :show] do
        resources  :addresses, :only => [:index, :show, :edit, :update, :new, :create]
      end
    end

    namespace :fulfillment do
      resources  :orders do
        member do
          put :create_shipment
        end
        resources  :comments
      end
      resources  :shipments do
        member do
          put :ship
        end
        resources  :addresses , :only => [:edit, :update]# This is for editing the shipment address
      end
    end
    namespace :shopping do
      resources :carts
      resources :products
      resources :users
      namespace :checkout do
        resources :billing_addresses, :only => [:index, :update, :new, :create, :select_address] do
          member do
            put :select_address
          end
        end
        resources :credit_cards
        resource  :order, :only => [:show, :update, :start_checkout_process] do
          member do
            post :start_checkout_process
          end
        end
        resources :shipping_addresses, :only => [:index, :update, :new, :create, :select_address] do
          member do
            put :select_address
          end
        end
        resources :shipping_methods, :only => [:index, :update]
      end
    end
    namespace :config do
      resources :accounts
      resources :overviews
      resources :shipping_categories
      resources :shipping_rates
      resources :shipping_methods
      resources :shipping_zones
      resources :tax_rates
      resources :tax_categories
      resources :messages
    end

    namespace :generic do
      resources :coupons
      resources :deals
    end
    namespace :inventory do
      resources :suppliers
      resources :overviews
      resources :purchase_orders
      resources :receivings
      resources :adjustments
    end

    namespace :merchandise do
      namespace :images do
        resources :products
      end
      resources :properties
      resources :prototypes
      resources :brands
      resources :product_types
      resources :prototype_properties

      namespace :changes do
        resources :products do
          resource :property,          :only => [:edit, :update]
        end
      end

      namespace :wizards do
        resources :brands,              :only => [:index, :create, :update]
        resources :products,            :only => [:new, :create]
        resources :properties,          :only => [:index, :create, :update]
        resources :prototypes,          :only => [:update]
        resources :tax_categories,        :only => [:index, :create, :update]
        resources :shipping_categories, :only => [:index, :create, :update]
        resources :product_types,       :only => [:index, :create, :update]
      end

      namespace :multi do
        resources :products do
          resource :variant,      :only => [:edit, :update]
        end
      end
      resources :products do
        member do
          get :add_properties
          put :activate
          get :featured
        end
        resources :variants
      end
      namespace :products do
        resources :descriptions, :only => [:edit, :update]
      end
    end
    namespace :document do
      resources :invoices
    end
  end

  match '/subregion_options', to: 'application#subregion_options'
  match '/artworks/:id', :to => 'products#show', :as => 'artwork'

  match '/myprofile', :to => 'profile#show', :as => 'myprofile'
  match '/profile/:profile_id/products', :to => 'profiles/products#index', :as => 'profile_products'
  match '/profile/:profile_id/collections', :to => 'profiles/collections#index', :as => 'profile_collections'
  match '/profile/:id', :to => 'profile#show', :as => 'profile'
  match '/:username', :to => 'profile#show', :as => 'personal_urls'
  post '/webhooks/receptor'
end
