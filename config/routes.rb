Rails.application.routes.draw do
  get "/" => "home#index"
  get '/api' => redirect('/dist/index.html?url=/api-docs.json')
  namespace :api do 
    namespace :v1 do 
      resources :auths
      resources :users do 
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
        get "/projects" => "projects#index"
        post "/projects" => "projects#create"
        get "/project" => "projects#show"
        get "/issues" => "issues#index"
        post "/issues" => "issues#create"
        get "/issue" => "issues#show"
        get "/issuetypes" => "issuetypes#index"
        get "/jirausers" => "jirausers#index"
        post "/comment" => "comments#create"
        get "/comment" => "comments#show"
        delete "/comment" => "comments#destroy"
        get "/comments" => "comments#index"
        get "/token" => "token#token"
        post "/moderator" => "moderators#create"
        post   "/login"   => "sessions#create"
        delete "/logout"  => "sessions#destroy"
        post '/forgot', to: 'passwords#forgot'
        post '/reset', to: 'passwords#reset'
      end
    end
  end
end