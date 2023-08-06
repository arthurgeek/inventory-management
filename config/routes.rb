# frozen_string_literal: true

Rails.application.routes.draw do
  # sessions
  post   'login',   to: 'sessions#create'
  delete 'logout',  to: 'sessions#destroy'
  get    'login',   to: 'sessions#new'

  # deliveries
  get 'accept_delivery', to: 'deliveries#new'
  post 'accept_delivery', to: 'deliveries#create'

  # inventory
  get 'inventory', to: 'inventory#index'

  root 'dashboard#index'
end
