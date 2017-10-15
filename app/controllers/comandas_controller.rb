class ComandasController < ApplicationController
  before_action :set_comanda, only: [:show, :edit, :update, :destroy, :close]
  before_action :check_comanda, only: [:edit, :update, :destroy]
  before_action :check_corte, only: [:new, :create]

  # GET /comandas
  # GET /comandas.json
  def index
    if params[:q].blank?
      params[:q] = {}
      params[:q][:created_at_gteq] = Time.now.beginning_of_day
      params[:q][:created_at_lteq] = Time.now.end_of_day
    end

    dia = params[:q][:created_at_gteq].to_date

    @q = Comanda.ransack(params[:q])
    @comandas = @q.result(distinct: true).order(created_at: :desc)
    @corte = Corte.find_by(dia: dia)

    redirect_to edit_corte_path(Corte.last), notice: "Por favor, primero cierra el corte del día anterior." if @corte.nil?
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
        format.html { redirect_to @comanda, notice: 'Actualizada exitosamente.' }
        format.json { render :show, status: :ok, location: @comanda }
      else
        format.html { render :edit }
        format.json { render json: @comanda.errors, status: :unprocessable_entity }
      end
    end
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

  def close
    @comanda.closed_at = Time.now
    @comanda.save
    respond_to do |format|
      format.html { redirect_to comandas_url, notice: '¡Cerrada!' }
      format.json { head :no_content }
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
      redirect_to comandas_path, notice: '¡Imposible! El corte de este día ya está cerrado.' unless Corte.actual.abierto?

    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comanda_params
      params.require(:comanda).permit(:mesa, :total, :descuento, :mesero_id, ordenes_attributes: [:id, :articulo_id, :cantidad, :_destroy, extra_ordenes_attributes: [:id, :extra_id, :_destroy]])
    end
end
