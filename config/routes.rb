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

  namespace :contabilidad do
    resources :cuentas, only: [:index, :new]
    resources :entradas, only: [:index, :new, :create]
    namespace :reportes do
      get :balance_sheet
      get :income_statement
    end
  end

  root "cortes#index"
end
