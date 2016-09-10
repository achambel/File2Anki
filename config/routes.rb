Rails.application.routes.draw do
  get '/resume', to: 'resume#index'

  root 'converters#index'
  get '/converters', to: 'converters#index'
  post '/converters/upload', to: 'converters#upload'
end
