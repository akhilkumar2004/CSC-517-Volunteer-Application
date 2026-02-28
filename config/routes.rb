Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "sessions#new"


  get "volunteer/signup", to: "volunteers#new"
  post "volunteer/signup", to: "volunteers#create"
  get "volunteer/dashboard", to: "volunteers#show"
  get "volunteer/profile/edit", to: "volunteers#edit"
  patch "volunteer/profile", to: "volunteers#update"
  delete "volunteer/account", to: "volunteers#destroy"

  # unified login/logout for both volunteers and admins
  get "login", to: "sessions#new", as: :login
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy", as: :logout


  get "admin/dashboard", to: "admins#show"
  get "admin/profile/edit", to: "admins#edit"
  patch "admin/profile", to: "admins#update"

  resources :events, only: %i[index show]

  resources :volunteer_assignments, only: %i[index create destroy]
  get "volunteer/history", to: "volunteer_assignments#history"
  post "events/:event_id/signups", to: "volunteer_assignments#create", as: :event_signups

  namespace :admin do
    resources :volunteers
    resources :events
    resources :volunteer_assignments, only: %i[index new create edit update destroy] do
      member do
        post :approve
      end
    end
    get "analytics", to: "analytics#index"
  end
end
