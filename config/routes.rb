Rails.application.routes.draw do
  resources :categorias
  resources :gastos
  resources :cortes
  resources :extras
  resources :ordenes
  resources :comandas do
    member do
      get :pay
      post :print
      patch :close
    end
  end
  resources :meseros
  resources :articulos

  root "cortes#index"
end
