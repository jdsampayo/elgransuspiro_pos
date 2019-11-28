# == Schema Information
#
# Table name: gastos
#
#  id          :uuid             not null, primary key
#  monto       :decimal(, )      default(0.0)
#  descripcion :text
#  created_at  :datetime
#  updated_at  :datetime
#  deleted_at  :datetime
#  corte_id    :uuid
#

class GastosController < ApplicationController
  load_and_authorize_resource

  before_action :set_corte, only: [:index, :show, :new, :create]
  before_action :set_gasto, only: [:show, :edit, :update, :destroy]

  # GET /gastos
  def index
    @gastos = @corte.gastos.order(created_at: :desc).page(params[:page])
  end

  # GET /gastos/1
  def show
  end

  # GET /gastos/new
  def new
    @gasto = Gasto.new
    @gasto.corte = @corte
  end

  # GET /gastos/1/edit
  def edit
  end

  # POST /gastos
  def create
    @gasto = Gasto.new(gasto_params)

    if @gasto.save
      @gasto.syncronize_create
      redirect_to gastos_path, notice: 'Se agregó el gasto exitosamente.'
    else
      render :new
    end
  end

  # PATCH/PUT /gastos/1
  def update
    if @gasto.update(gasto_params)
      @gasto.syncronize_update
      redirect_to gastos_path, notice: 'Se actualizó exitosamente.'
    else
      render :edit
    end
  end

  # DELETE /gastos/1
  def destroy
    @gasto.destroy
    @gasto.syncronize_destroy
    redirect_to gastos_url, notice: 'Eliminado.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_corte
      @corte = current_corte
    end

    def set_gasto
      @gasto = Gasto.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def gasto_params
      params.require(:gasto).permit(:monto, :descripcion, :corte_id)
    end
end
