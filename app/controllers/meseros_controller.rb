# == Schema Information
#
# Table name: meseros
#
#  id         :uuid             not null, primary key
#  nombre     :text
#  created_at :datetime
#  updated_at :datetime
#  deleted_at :datetime
#

class MeserosController < ApplicationController
  load_and_authorize_resource

  before_action :set_mesero, only: [:show, :edit, :update, :destroy]

  # GET /meseros
  def index
    @meseros = Mesero.with_attached_avatar.kept.order(:nombre)
  end

  # GET /meseros/1
  def show
  end

  # GET /meseros/new
  def new
    @mesero = Mesero.new
  end

  # GET /meseros/1/edit
  def edit
  end

  # POST /meseros
  def create
    @mesero = Mesero.new(mesero_params)

    if @mesero.save
      @mesero.syncronize_create

      redirect_to @mesero, notice: 'Creado exitosamente.'
    else
      render :new
    end
  end

  # PATCH/PUT /meseros/1
  def update
    if @mesero.update(mesero_params)
      @mesero.syncronize_update

      redirect_to @mesero, notice: 'Actualizado exitosamente.'
    else
      render :edit
    end
  end

  # DELETE /meseros/1
  def destroy
    @mesero.discard
    @mesero.syncronize_destroy

    redirect_to meseros_url, notice: 'Eliminado correctamente.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mesero
      @mesero = Mesero.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def mesero_params
      params.require(:mesero).permit(:nombre, :avatar)
    end
end
