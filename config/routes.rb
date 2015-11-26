Rails.application.routes.draw do
  root "users#doc"

  post "/user/new" => "users#create"
  post "/auth/login" => "authorizations#create"
  get "/auth/logout" => "authorizations#destroy"

  namespace :api do
    namespace :v1 do
      resources :bucketlists
      resources :items
    end
  end

  match ":not_found" => "users#doc", via: :all, constraints: { not_found: /.*/ }
end
