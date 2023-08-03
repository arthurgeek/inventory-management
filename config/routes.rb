# frozen_string_literal: true

Rails.application.routes.draw do
  # sessions
  post   'login',   to: 'sessions#create'
  delete 'logout',  to: 'sessions#destroy'
  get    'login',   to: 'sessions#new'

  root 'dashboard#index'
end
