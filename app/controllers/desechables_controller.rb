class DesechablesController < ApplicationController
  load_and_authorize_resource

  before_action :set_desechable, only: [:show, :edit, :update, :destroy]

  # GET /desechables
  def index
    @desechables = Desechable.order(cantidad: :asc)
  end

  # GET /desechables/1
  def show
  end

  # GET /desechables/new
  def new
    @desechable = Desechable.new
  end

  # GET /desechables/1/edit
  def edit
  end

  # POST /desechables
  def create
    @desechable = Desechable.new(desechable_params)

    if @desechable.save
      @desechable.syncronize_create

      redirect_to @desechable, notice: 'Creado exitosamente.'
    else
      render :new
    end
  end

  # PATCH/PUT /desechables/1
  def update
    if @desechable.update(desechable_params)
      @desechable.syncronize_update

      redirect_to @desechable, notice: 'Actualizado exitosamente.'
    else
      render :edit
    end
  end

  # DELETE /desechables/1
  def destroy
    @desechable.destroy
    @desechable.syncronize_delete

    redirect_to desechables_url, notice: 'Eliminado exitosamente.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_desechable
      @desechable = Desechable.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def desechable_params
      params.require(:desechable).permit(:nombre, :en_bodega, :cantidad, :costo_unitario)
    end
end
