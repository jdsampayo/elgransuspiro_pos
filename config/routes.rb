Rails.application.routes.draw do
  # Serve websocket cable requests in-process
  mount ActionCable.server => '/cable'

  # namespaces
  namespace :admin do
    resources :comandas
    
    resources :cortes do
      resources :comandas
    end
  end
  namespace :contabilidad do
    resources :cuentas, only: [:index, :new]
    resources :entradas, only: [:index, :new, :create, :destroy]
    namespace :reportes do
      get :balance_sheet
      get :income_statement
      get :cash_flow
      get :monthly
    end
  end

  # root resources
  resources :articulos do
    collection do
      get :report
    end
  end
  resources :asistencias
  resources :categorias
  resources :desechables
  resources :comandas do
    member do
      get :pay
      post :print
      get :switch
      patch :close
    end
  end
  resources :conteos
  resources :cortes do
    collection do
      get :propinas
    end
    resources :asistencias
    resources :comandas
    resources :gastos
  end
  resources :cuentas
  resources :extras
  resources :gastos
  resources :insumos
  resources :meseros
  resources :ordenes
  resources :sesiones
  resources :sucursales do
    collection do
      get :set
    end
  end

  get 'propinas', controller: 'cortes', action: 'propinas', as: 'propinas'
  get 'acceso_denegado', controller: 'sesiones', action: 'acceso_denegado', as: 'acceso_denegado'
  get 'login', controller: 'sesiones', action: 'new', as: 'login'
  get 'logout', controller: 'sesiones', action: 'destroy', as: 'logout'
  get 'admin', controller: 'tableros', action: 'admin', as: 'admin'

  root 'tableros#index'
end
