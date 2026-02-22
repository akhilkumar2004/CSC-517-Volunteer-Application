Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "home#index"

  get "volunteer/signup", to: "volunteers#new"
  post "volunteer/signup", to: "volunteers#create"
  get "volunteer/dashboard", to: "volunteers#show"
  get "volunteer/profile/edit", to: "volunteers#edit"
  patch "volunteer/profile", to: "volunteers#update"
  delete "volunteer/account", to: "volunteers#destroy"

  get "volunteer/login", to: "volunteer_sessions#new"
  post "volunteer/login", to: "volunteer_sessions#create"
  delete "volunteer/logout", to: "volunteer_sessions#destroy"

  get "admin/login", to: "admin_sessions#new"
  post "admin/login", to: "admin_sessions#create"
  delete "admin/logout", to: "admin_sessions#destroy"

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
    resources :volunteer_assignments, only: %i[index new create edit update destroy]
    get "analytics", to: "analytics#index"
  end
end
