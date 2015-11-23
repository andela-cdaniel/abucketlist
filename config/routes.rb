Rails.application.routes.draw do

  # get 'authorizations/create'

  # get 'authorizations/destroy'

  # get 'users/create'

  post "/user/new" => "users#create"
  post "/auth/login" => "authorizations#create"
  delete "/auth/logout" => "authorizations#destroy"

  namespace :api do
    namespace :v1 do
      resources :bucketlists
      resources :items
    end
  end
end
