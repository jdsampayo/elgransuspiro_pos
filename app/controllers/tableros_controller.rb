class TablerosController < ApplicationController
  before_action :requiere_corte_actual, only: [:index]

  def index
    @total_de_productos = Orden.where(comanda_id: Corte.actual.comandas).sum(:cantidad)
  end
end
