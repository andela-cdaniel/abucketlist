Rails.application.routes.draw do
  root "users#index"

  post "/user/new" => "users#create"
  post "/auth/login" => "authorizations#create"
  get "/auth/logout" => "authorizations#destroy"

  namespace :api do
    namespace :v1 do
      resources :bucketlists, except: [:new, :edit] do
        resources :items, only: [:create, :update, :destroy]
      end
    end
  end

  match ":not_found" => "users#doc", via: :all, constraints: { not_found: /.*/ }
end
