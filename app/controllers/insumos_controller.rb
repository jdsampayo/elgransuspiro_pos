# == Schema Information
#
# Table name: insumos
#
#  id                   :uuid             not null, primary key
#  nombre               :string
#  cantidad_actual      :integer          default(0)
#  unidad               :string
#  deleted_at           :datetime
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  paquete              :enum
#  cantidad_por_paquete :integer          default(0)
#

class InsumosController < ApplicationController
  before_action :set_insumo, only: [:show, :edit, :update, :destroy]

  # GET /insumos
  def index
    @insumos = Insumo.kept
  end

  # GET /insumos/1
  def show
  end

  # GET /insumos/new
  def new
    @insumo = Insumo.new
  end

  # GET /insumos/1/edit
  def edit
  end

  # POST /insumos
  def create
    @insumo = Insumo.new(insumo_params)

    if @insumo.save
      redirect_to @insumo, notice: 'El insumo se creó exitosamente.'
    else
      render :new
    end
  end

  # PATCH/PUT /insumos/1
  def update
    if @insumo.update(insumo_params)
      redirect_to @insumo, notice: 'El insumo se actualizó exitosamente.'
    else
      render :edit
    end
  end

  # DELETE /insumos/1
  def destroy
    @insumo.discard

    redirect_to insumos_url, notice: 'El insumo se eliminó correctamente.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_insumo
      @insumo = Insumo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def insumo_params
      params.require(:insumo).permit(
        :nombre,
        :cantidad_actual,
        :unidad,
        :paquete,
        :cantidad_por_paquete
      )
    end
end
