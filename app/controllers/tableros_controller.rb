class TablerosController < ApplicationController
  before_action :requiere_corte_actual, only: [:index]

  def index
    @total_de_articulos = Articulo.all.count

    conteos = Conteo.group(:articulo_id).order('sum_total DESC').limit(10).sum(:total)
    @conteos = Hash[conteos.map { |k, v| [Articulo.find(k).nombre.titleize, v] }]

    @comandas = Comanda.all

    @estancia_promedia = @comandas.unscoped.pluck("Cast ((julianday(closed_at) - julianday(created_at)) * 24 * 60 * 60 As Integer) as estancia_promedio").compact

    @estancia_promedia = @estancia_promedia.sum / @estancia_promedia.count
    @total_de_productos = Orden.where(comanda_id: @comandas).sum(:cantidad)
    @total_de_ventas = @comandas.sum(:total)
    @cheque_promedio = @total_de_ventas / @comandas.sum(:comensales)

    @gastos_por_dia = Gasto.group_by_day(:created_at, time_zone: false).sum(:monto)
  end
end
