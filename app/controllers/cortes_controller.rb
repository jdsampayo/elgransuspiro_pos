class CortesController < ApplicationController
  before_action :set_corte, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  # GET /cortes
  # GET /cortes.json
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

  # GET /cortes/1
  # GET /cortes/1.json
  def show
    @comandas = @corte.comandas
    @gastos = @corte.gastos_del_dia

    @con_tarjeta = @comandas.con_tarjeta
    @con_efectivo = @comandas.con_efectivo

    @total_comandas_cerradas = @comandas.cerradas.sum(:total)
    @total_con_tarjeta = @con_tarjeta.cerradas.sum(:total)

    @total_de_gastos = @gastos.sum(:monto)

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

    respond_to do |format|
      if @corte.save
        format.html { redirect_to comandas_path, notice: 'El corte se creó exitosamente.' }
        format.json { render :show, status: :created, location: @corte }
      else
        format.html { render :new }
        format.json { render json: @corte.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cortes/1
  # PATCH/PUT /cortes/1.json
  def update
    respond_to do |format|
      if @corte.update(corte_params)
        @corte.cerrar
        format.html { redirect_to comandas_path, notice: 'El corte se cerró correctamente.' }
        format.json { render :show, status: :ok, location: @corte }
      else
        format.html { render :edit }
        format.json { render json: @corte.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cortes/1
  # DELETE /cortes/1.json
  def destroy
    @corte.destroy
    respond_to do |format|
      format.html { redirect_to cortes_url, notice: 'El Corte se eliminó correctamente.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_corte
      @corte = Corte.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def corte_params
      params.require(:corte).permit(:dia, :inicial, :ventas, :gastos, :total, :siguiente_dia, :sobre)
    end
end
