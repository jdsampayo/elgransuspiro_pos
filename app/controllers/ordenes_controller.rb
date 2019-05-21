# == Schema Information
#
# Table name: ordenes
#
#  id              :uuid             not null, primary key
#  articulo_id     :uuid
#  comanda_id      :uuid
#  cantidad        :bigint(8)
#  precio_unitario :decimal(, )      default(0.0)
#  created_at      :datetime
#  updated_at      :datetime
#  para_llevar     :boolean
#  deleted_at      :datetime
#

class OrdenesController < ApplicationController
  load_and_authorize_resource

  before_action :set_orden, only: [:show, :edit, :update, :destroy]

  # GET /ordenes
  # GET /ordenes.json
  def index
    @ordenes = Orden.all
  end

  # GET /ordenes/1
  # GET /ordenes/1.json
  def show
  end

  # GET /ordenes/new
  def new
    @orden = Orden.new
  end

  # GET /ordenes/1/edit
  def edit
  end

  # POST /ordenes
  # POST /ordenes.json
  def create
    @orden = Orden.new(orden_params)

    respond_to do |format|
      if @orden.save
        format.html { redirect_to @orden, notice: 'Orden was successfully created.' }
        format.json { render :show, status: :created, location: @orden }
      else
        format.html { render :new }
        format.json { render json: @orden.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ordenes/1
  # PATCH/PUT /ordenes/1.json
  def update
    respond_to do |format|
      if @orden.update(orden_params)
        format.html { redirect_to @orden, notice: 'Orden was successfully updated.' }
        format.json { render :show, status: :ok, location: @orden }
      else
        format.html { render :edit }
        format.json { render json: @orden.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ordenes/1
  # DELETE /ordenes/1.json
  def destroy
    @orden.destroy
    respond_to do |format|
      format.html { redirect_to ordenes_url, notice: 'Orden was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_orden
      @orden = Orden.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def orden_params
      params.require(:orden).permit(:articulo_id, :comanda_id, :cantidad)
    end
end
