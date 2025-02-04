# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check
  resources :orders, only: %i[new create show]
  %i[pizzas toppings sides].each do |resource|
    resources resource, only: %i[create index show update] do
      member { post :restock }
    end
  end
  # Defines the root path route ("/")
  root 'pizzas#index'
end
