Rails.application.routes.draw do
  resources :desechables
  resources :conteos
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
  resources :cuentas

  root "cortes#index"

  mount Plutus::Engine => "/contabilidad", as: "contabilidad"
end
