Rails.application.routes.draw do
  root 'flights#index'
  resources :flights

  post '/flight_path' => 'flights#calculate_path'
end
