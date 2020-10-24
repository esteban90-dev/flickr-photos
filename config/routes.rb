Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get '/photos', to: 'static_pages#index'
  root 'static_pages#index'
end
