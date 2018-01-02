class ComandasController < ApplicationController
  before_action :set_comanda, only: [:show, :edit, :update, :destroy, :pay, :close, :print]
  before_action :check_comanda, only: [:edit, :update, :destroy]
  before_action :check_corte, only: [:new, :create]

  # GET /comandas
  # GET /comandas.json
  def index
    if params[:corte_id].blank?
      corte_actual = Corte.actual

      if corte_actual.nil?
        redirect_to edit_corte_path(Corte.last), notice: "Por favor, primero cierra el corte del día anterior."
        return
      end

      params[:corte_id] = corte_actual.id
    end

    @corte = Corte.find(params[:corte_id])
    @comandas = @corte.comandas.order([closed_at: :asc])

    @comandas_cerradas = @comandas.cerradas.sum(:total)
    @gastos = Gasto.del_dia(@corte.dia).sum(:monto)

    @propinas = @comandas.sum(:propina)
  end

  # GET /comandas/1
  # GET /comandas/1.json
  def show
  end

  # GET /comandas/new
  def new
    @comanda = Comanda.new
    3.times { @comanda.ordenes.build }
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

    respond_to do |format|
      if @comanda.save
        format.html { redirect_to @comanda, notice: 'Creada exitosamente.' }
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
