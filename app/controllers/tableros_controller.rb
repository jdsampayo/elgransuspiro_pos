class TablerosController < ApplicationController
  load_and_authorize_resource class: false

  def index
    if current_user.admin?
      redirect_to admin_path
      return
    end

    @corte = current_corte
    @total_de_articulos = Articulo.kept.count

    conteos = Conteo.de_articulos
    @conteos = Hash[
      conteos.map do |k, v|
        [Articulo.unscoped.find(k).to_s, v]
      end
    ]

    @comandas = Comanda.kept

    @estancia_promedia = @comandas.unscoped.pluck(
      'extract(epoch from (closed_at - created_at)) as estancia_promedio'
    ).compact

    @estancia_promedia = @estancia_promedia.sum / @estancia_promedia.count
    @total_de_productos = Orden.where(comanda_id: @comandas).sum(:cantidad)
    @total_de_ventas = @comandas.sum(:total)
    @cheque_promedio = @total_de_ventas / @comandas.sum(:comensales)

    @gastos_por_dia = Gasto.where(
      created_at: 3.months.ago..1.day.ago
    ).group_by_day(:created_at, time_zone: false).sum(:monto)
  end

  def admin
    @to_date = to_date(params)

    cortes = Corte.joins(:sucursal).where(dia: @to_date).order("sucursales.nombre")

    @series = cortes.map do | corte |
      {
        name: corte.sucursal.to_s,
        data: corte.ventas_por_hora, prefix: "$ ", thousands: ","
      }
    end

    comandas = Comanda.where(corte: cortes).kept

    if @to_date != Date.today
      @ventas = cortes.sum(:ventas)
      @gastos = cortes.sum(:sum_gastos)
      @efectivo = cortes.sum(:pagos_con_efectivo)
      @tarjeta = cortes.sum(:pagos_con_tarjeta)
    else
      @ventas = comandas.sum(:total)
      @gastos = Gasto.where(corte: cortes).kept.sum(:monto)
      @efectivo = comandas.sum(:pago_con_efectivo)
      @tarjeta = comandas.sum(:pago_con_tarjeta)
      @propinas_con_efectivo = comandas.sum(:propina_con_efectivo)
      @propinas_con_tarjeta = comandas.sum(:propina_con_tarjeta)
    end

    @inicial = cortes.sum(:inicial)
    @siguiente_dia = cortes.sum(:siguiente_dia)
    @propinas_con_efectivo = comandas.sum(:propina_con_efectivo)
    @propinas_con_tarjeta = comandas.sum(:propina_con_tarjeta)

    @dinero_en_caja = @inicial + @efectivo + @propinas_con_efectivo - @gastos - @siguiente_dia
    @dinero_a_entregar = @dinero_en_caja - @propinas_con_efectivo - @propinas_con_tarjeta
  end

  private

  def to_date(params)
    return Date.parse(params[:date]) if params[:date]

    Date.today
  end
end
