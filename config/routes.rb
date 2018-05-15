Rails.application.routes.draw do
  resources :asistencias
  resources :desechables
  resources :conteos
  resources :categorias
  resources :gastos
  resources :cortes do
    collection do
      get :propinas
    end
  end
  resources :extras
  resources :ordenes
  resources :comandas do
    member do
      get :pay
      post :print
      post :switch
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

  resources :sesiones

  get "propinas", controller: "cortes", action: "propinas", as: "propinas"
  get "acceso_denegado", controller: "sesiones", action: "acceso_denegado", as: "acceso_denegado"
  get "login", controller: "sesiones", action: "new", as: "login"
  get "logout", controller: "sesiones", action: "destroy", as: "logout"

  if Rails.env.development?
    root "tableros#index"
  else
    root "contabilidad/cuentas#index"
  end
end
