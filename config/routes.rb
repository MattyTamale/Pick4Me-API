Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/favorites', to: 'favorites#index'

  get '/favorites/:id', to: 'favorites#show'

  post '/favorites', to: 'favorites#create'

  delete '/favorites/:id', to: 'favorites#delete'

  put '/favorites/:id', to: 'favorites#update'

end
