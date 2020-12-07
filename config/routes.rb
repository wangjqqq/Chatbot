Rails.application.routes.draw do
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


  resources :users do
    collection do
      get :index_json
    end
  end

  resources :messages do
    collection do
      delete :destroyall
    end
  end

  resources :chats do
    member do
      patch :trans_auth
      post :add_user
      delete :delete_user
    end
  end

  resources :friendships

  root 'homes#home'

  get 'sessions/login' => 'sessions#new'
  post 'sessions/login' => 'sessions#create'
  delete 'sessions/logout' => 'sessions#destroy'
  get 'sessions/logout' => 'sessions#destroy'

  get 'chatroom/' => 'chats#chatroom'
  post 'sendtorobot/' => 'messages#sendtorobot'
  post 'createarticle/' => 'articles#create'
  # delete 'createarticle/:id' => 'articles#delete'
  resources :articles, :only => [:destroy, :show]
  resources :footsteps, :only => [:create]
  post 'updatelike/' => 'articles#update'
  get 'developlog/' => 'developlog#index'

end
