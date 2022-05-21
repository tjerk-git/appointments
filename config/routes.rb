Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  get '/register/:app_id', to: 'installation#index'
  get '/spots', to: 'spots#index'
  get '/spots/:calendar_id/:name', to: 'spots#show'

  post '/calendars/', to: 'calendars#create'
  post '/spots/', to: 'spots#create'
end
