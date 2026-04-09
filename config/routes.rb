# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  namespace :api do
    resources :users, only: [] do
      resources :recommendations, only: %i[index create], controller: 'users/recommendations' do
        delete :destroy, on: :member

        collection do
          resource :item_interactions, only: %i[show], controller: 'users/item_interactions' do
            post ':menu_item_id/like', action: :like, on: :collection
            post ':menu_item_id/dislike', action: :dislike, on: :collection
          end
        end
      end
    end
  end
end
