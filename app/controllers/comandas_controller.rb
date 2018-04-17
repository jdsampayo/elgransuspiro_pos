class ComandasController < ApplicationController
  before_action :set_comanda, only: [:show, :edit, :update, :destroy, :pay, :close, :print]
  before_action :check_comanda, only: [:edit, :update, :destroy]
  before_action :check_corte, only: [:new, :create]

  # GET /comandas
  # GET /comandas.json
  def index
    if params[:corte_id].blank?
      corte_actual = Corte.actual

      unless corte_actual
        redirect_to edit_corte_path(Corte.last), notice: "Por favor, primero realiza el corte del día anterior."
        return
      end

      params[:corte_id] = corte_actual.id
    end

    @corte = Corte.find(params[:corte_id])
    @comandas = @corte.comandas.order([closed_at: :asc])
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

    unless @estancia_promedia.empty?
      @estancia_promedia = @estancia_promedia.sum / @estancia_promedia.count 
    else
      @estancia_promedia = nil
    end

    @total_de_productos = Orden.where(comanda_id: @comandas).sum(:cantidad)

    @cheque_promedio = @total_de_ventas / @comandas.sum(:comensales) unless @comandas.empty?
  end

  # GET /comandas/1
  # GET /comandas/1.json
  def show
  end

  # GET /comandas/new
  def new
    @comanda = Comanda.new
    1.times { @comanda.ordenes.build }
  end

  # GET /comandas/1/edit
  def edit
    redirect_to @comanda unless @comanda.abierta?
  end

  # POST /comandas
  # POST /comandas.json
  def create
    @comanda = Comanda.new(comanda_params)
    @comanda.corte = Corte.actual
    @comanda.descuento ||= 0

    respond_to do |format|
      if @comanda.save
        format.html { redirect_to @comanda, success: '¡La comanda fue creada exitosamente!' }
        format.json { render :show, status: :created, location: @comanda }
      else
        format.html { render :new }
        format.json { render json: @comanda.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comandas/1
  # PATCH/PUT /comandas/1.json
  def update
    respond_to do |format|
      if @comanda.update(comanda_params)
        @comanda.set_totales
        @comanda.save
        format.html { redirect_to @comanda, notice: 'Actualizada exitosamente.' }
        format.json { render :show, status: :ok, location: @comanda }
      else
        format.html { render :edit }
        format.json { render json: @comanda.errors, status: :unprocessable_entity }
      end
    end
  end

  def print
    @comanda.print_ticket

    redirect_to comandas_url, notice: '¡Impresa!'
  end

  # DELETE /comandas/1
  # DELETE /comandas/1.json
  def destroy
    @comanda.destroy
    respond_to do |format|
      format.html { redirect_to comandas_url, notice: 'Eliminada.' }
      format.json { head :no_content }
    end
  end

  def pay
  end

  def close
    respond_to do |format|
      if @comanda.update(close_comanda_params)
        @comanda.cerrar
        format.html { redirect_to comandas_url, notice: '¡Cerrada!' }
        format.json { head :no_content }
      else
        format.html { render :edit }
        format.json { render json: @comanda.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comanda
      @comanda = Comanda.find(params[:id])
    end

    def check_comanda
      redirect_to @comanda, notice: '¡Imposible! La comanda ya se encuentra cerrada.' unless @comanda.abierta?
    end

    def check_corte
      if Corte.actual.nil? || Corte.actual.cerrado?
        redirect_to comandas_path, notice: '¡Imposible! El corte de este día ya está cerrado.'
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comanda_params
      params.require(:comanda).permit(
        :mesa,
        :total,
        :descuento,
        :mesero_id,
        :comensales,
        ordenes_attributes: [
          :id,
          :articulo_id,
          :cantidad,
          :para_llevar,
          :_destroy,
          extra_ordenes_attributes: [
            :id,
            :extra_id,
            :_destroy
          ]
        ]
      )
    end

    def close_comanda_params
      params.require(:comanda).permit(:pago_con_tarjeta, :propina)
    end
end
