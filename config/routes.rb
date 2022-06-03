Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  get '/register/:app_id', to: 'installation#index'
  post '/spots-update/', to: 'installation#get_spots'

  get '/spots', to: 'spots#index'
  get '/spots/:calendar_id/:name', to: 'spots#show', as: 'spot_reserve'
  get '/spots/:calendar_id/:name/:id', to: 'spots#show_spot', as: 'spot'
  get '/spots/reserve-complete', to: 'spots#complete', as: 'spot_complete'

  post '/spots/delete', to: 'spots#delete_spots'

  post '/calendars/', to: 'calendars#create'
  post '/spots/', to: 'spots#create'
  patch '/spots/reserve/:spot_id', to: 'spots#reserve'
end
