Rails.application.routes.draw do
  
  
  get "/" => "home#index"
  get '/api' => redirect('/dist/index.html?url=/api-docs.json')
  namespace :api do 
    namespace :v1 do 
      resources :users do 
        # new routes go here 
        resources :clients do
          get "/export" => "export#index"
          resources :epics do 
            resources :stories do 
              resources :subtasks
            end
          end
        end

      end
      scope do
        post "/moderator" => "moderators#create"
        post   "/login"   => "sessions#create"
        delete "/logout"  => "sessions#destroy"
        post '/forgot', to: 'passwords#forgot'
        post '/reset', to: 'passwords#reset'
      end
    end
  end
end