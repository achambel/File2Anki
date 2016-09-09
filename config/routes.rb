Rails.application.routes.draw do
  root 'converters#index'
  get '/converters', to: 'converters#index'
  post '/converters/upload', to: 'converters#upload'
end
