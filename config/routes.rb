Rails.application.routes.draw do
  resources :gastos
  resources :cortes
  resources :extras
  resources :ordenes
  resources :comandas do
    member do
      post :print
      post :close
    end
  end
  resources :meseros
  resources :articulos

  root "cortes#index"
end
