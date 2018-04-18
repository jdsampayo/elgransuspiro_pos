class TablerosController < ApplicationController
  def index
    @total_de_productos = Orden.where(comanda_id: Corte.actual.comandas).sum(:cantidad)
  end
end
