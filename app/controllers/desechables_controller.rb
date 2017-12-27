class DesechablesController < ApplicationController
  before_action :set_desechable, only: [:show, :edit, :update, :destroy]

  # GET /desechables
  # GET /desechables.json
  def index
    @desechables = Desechable.order(cantidad: :asc)
  end

  # GET /desechables/1
  # GET /desechables/1.json
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
  # POST /desechables.json
  def create
    @desechable = Desechable.new(desechable_params)

    respond_to do |format|
      if @desechable.save
        format.html { redirect_to @desechable, notice: 'Creado exitosamente.' }
        format.json { render :show, status: :created, location: @desechable }
      else
        format.html { render :new }
        format.json { render json: @desechable.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /desechables/1
  # PATCH/PUT /desechables/1.json
  def update
    respond_to do |format|
      if @desechable.update(desechable_params)
        format.html { redirect_to @desechable, notice: 'Actualizado exitosamente.' }
        format.json { render :show, status: :ok, location: @desechable }
      else
        format.html { render :edit }
        format.json { render json: @desechable.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /desechables/1
  # DELETE /desechables/1.json
  def destroy
    @desechable.destroy
    respond_to do |format|
      format.html { redirect_to desechables_url, notice: 'Eliminado exitosamente.' }
      format.json { head :no_content }
    end
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
