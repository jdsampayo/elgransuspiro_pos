class CortesController < ApplicationController
  load_and_authorize_resource

  before_action :set_corte, only: [:show, :edit, :update, :destroy]

  # GET /cortes
  def index
    @cortes = Corte.order(dia: :desc).page params[:page]

    @semana_actual = [
      {
        name: "Ventas",
        data: Corte.de_la_semana(Date.today, :ventas)
      },
      {
        name: "Gastos",
        data: Corte.de_la_semana(Date.today, :gastos)
      }
    ]
    @semana_anterior = [
      {
        name: "Ventas",
        data: Corte.de_la_semana(1.week.ago, :ventas)
      },
      {
        name: "Gastos",
        data: Corte.de_la_semana(1.week.ago, :gastos)
      }
    ]

    por_semana_query = Corte.group_by_week(:dia, time_zone: false)
    @por_semana = [
      {
        name: "Ventas",
        data: por_semana_query.sum(:ventas)
      },
      {
        name: "Gastos",
        data: por_semana_query.sum(:gastos)
      }
    ]
  end

  def propinas
    @cortes = Corte.includes(:asistencias).order(dia: :desc).page params[:page]

    @semana_actual = [
      {
        name: "Propinas",
        data: Corte.de_la_semana(Date.today, :propinas)
      }
    ]
    @semana_anterior = [
      {
        name: "Propinas",
        data: Corte.de_la_semana(1.week.ago, :propinas)
      }
    ]

    por_semana_query = Corte.group_by_week(:dia, time_zone: false)
    @por_semana = [
      {
        name: "Propinas",
        data: por_semana_query.sum(:propinas)
      }
    ]
  end

  # GET /cortes/1
  def show
    @comandas = @corte.comandas
    @gastos = Gasto.where(corte_id: @corte.id)

    @con_tarjeta = @comandas.con_tarjeta
    @con_efectivo = @comandas.con_efectivo

    @total_comandas_cerradas = @comandas.cerradas.sum(:total)
    @total_con_tarjeta = @con_tarjeta.cerradas.sum(:total)

    @total_de_gastos = @corte.gastos

    @caja = @corte.inicial + @total_comandas_cerradas - @total_con_tarjeta - @total_de_gastos

    @propinas = @comandas.sum(:propina)
    @total_de_ventas = @comandas.sum(:total)

    @estancia_promedia = @comandas.map do |comanda|
      comanda.closed_at - comanda.created_at if comanda.closed_at
    end.compact
    @estancia_promedia = @estancia_promedia.sum / @estancia_promedia.count unless @estancia_promedia.empty?

    @total_de_productos = Orden.where(comanda_id: @comandas).sum(:cantidad)

    @cheque_promedio = @total_de_ventas / @comandas.sum(:comensales) unless @comandas.empty?
  end

  # GET /cortes/new
  def new
    @corte = Corte.new
  end

  # GET /cortes/1/edit
  def edit
    @corte.set_subtotals
  end

  # POST /cortes
  # POST /cortes.json
  def create
    @corte = Corte.new(corte_params)

    if @corte.save
      @corte.syncronize_create
      redirect_to comandas_path, notice: 'El corte se creó exitosamente.'
    else
      render :new
    end
  end

  # PATCH/PUT /cortes/1
  def update
    if @corte.update(corte_params)
      @corte.cerrar
      @corte.syncronize_update
      redirect_to comandas_path, notice: 'El corte se cerró correctamente.'
    else
      render :edit
    end
  end

  # DELETE /cortes/1
  def destroy
    @corte.destroy
    redirect_to cortes_url, notice: 'El corte se eliminó correctamente.'
  end

  private
    def set_corte
      @corte = Corte.find(params[:id])
    end

    def corte_params
      params.require(:corte).permit(:dia, :inicial, :ventas, :gastos, :total, :siguiente_dia, :sobre)
    end
end
