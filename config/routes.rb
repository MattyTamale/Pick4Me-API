Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  ##################
  #FAVORITES ROUTES:
  ##################
  get '/favorites', to: 'favorites#index'

  get '/favorites/:id', to: 'favorites#show'

  post '/favorites', to: 'favorites#create'

  delete '/favorites/:id', to: 'favorites#delete'

  put '/favorites/:id', to: 'favorites#update'

  ##################
  #COMMENTS ROUTES:
  ##################
  get '/comments', to: 'comments#index'

  get '/comments/:id', to: 'comments#show'

  post '/comments', to: 'comments#create'

  delete '/comments/:id', to: 'comments#delete'

  put '/comments/:id', to: 'comments#update'

end
