class TablerosController < ApplicationController
  load_and_authorize_resource class: false

  before_action :requiere_corte_actual, only: [:index]

  def index
    @total_de_articulos = Articulo.all.count

    conteos = Conteo.group(:articulo_id).order('sum_total DESC').limit(10).sum(:total)
    @conteos = Hash[conteos.map { |k, v| [Articulo.unscoped.find(k).nombre.titleize, v] }]

    @comandas = Comanda.all

    @estancia_promedia = @comandas.unscoped.pluck("extract(epoch from (closed_at - created_at)) as estancia_promedio").compact

    @estancia_promedia = @estancia_promedia.sum / @estancia_promedia.count
    @total_de_productos = Orden.where(comanda_id: @comandas).sum(:cantidad)
    @total_de_ventas = @comandas.sum(:total)
    @cheque_promedio = @total_de_ventas / @comandas.sum(:comensales)

    @gastos_por_dia = Gasto.where(created_at: 3.months.ago..1.day.ago).group_by_day(:created_at, time_zone: false).sum(:monto)
  end
end
