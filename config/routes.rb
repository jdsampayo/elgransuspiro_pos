Rails.application.routes.draw do
  resources :insumos

  namespace :api do
    resources :asistencias, defaults: { format: 'json' }
    resources :desechables, defaults: { format: 'json' }
    resources :articulos, defaults: { format: 'json' }
    resources :gastos, defaults: { format: 'json' }
    resources :comandas, defaults: { format: 'json' }
    resources :cortes, defaults: { format: 'json' }
    resources :meseros, defaults: { format: 'json' }
  end

  resources :asistencias
  resources :desechables
  resources :conteos
  resources :categorias
  resources :cortes do
    collection do
      get :propinas
    end
    resources :comandas
    resources :gastos
    resources :asistencias
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
  resources :gastos
  resources :meseros
  resources :articulos do
    collection do
      get :report
    end
  end
  resources :cuentas
  resources :insumos

  namespace :contabilidad do
    resources :cuentas, only: [:index, :new]
    resources :entradas, only: [:index, :new, :create, :destroy]
    namespace :reportes do
      get :balance_sheet
      get :income_statement
      get :monthly
    end
  end

  resources :sesiones

  get 'propinas', controller: 'cortes', action: 'propinas', as: 'propinas'
  get 'acceso_denegado', controller: 'sesiones', action: 'acceso_denegado', as: 'acceso_denegado'
  get 'login', controller: 'sesiones', action: 'new', as: 'login'
  get 'logout', controller: 'sesiones', action: 'destroy', as: 'logout'

  if Rails.application.config.x.sucursal == 'matriz'
    root 'contabilidad/cuentas#index'
  else
    root 'tableros#index'
  end
end
