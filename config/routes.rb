Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "home#index"
  
  get '/register/:app_id', to: 'installation#index'
  post '/spots-update/', to: 'installation#get_spots'

  get '/spots/:calendar_id/:name', to: 'spots#index'
  #get '/spots/:calendar_id/:name/:id', to: 'spots#show', as: 'spot'
  get '/spot/reserve-complete', to: 'spots#complete', as: 'spot_complete'

  get '/spot/reserve/:spot_id', to: 'spots#reserve', as: 'spot_reserve'

  get '/spot/:slug', to: 'spots#show'
  get '/spot/ical/:slug', to: 'spots#show_ical', as: 'spot_ical'
  get '/spot/cancel/:slug', to: 'spots#cancel', as: 'spot_cancel'

  post '/spots/delete', to: 'spots#delete_spots'

  post '/calendars/', to: 'calendars#create'
  delete '/calendars/', to: 'calendars#destroy'
  post '/spots/', to: 'spots#create'
  patch '/spot/reserve/:spot_id', to: 'spots#claim'

  if Rails.env.development?
    get  '/remove_everything', to: 'hamaki_test#remove_everything'
    get '/get_all_calendars', to: 'hamaki_test#get_calendars'
  end


end
