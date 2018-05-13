class MeserosController < ApplicationController
  load_and_authorize_resource

  before_action :set_mesero, only: [:show, :edit, :update, :destroy]

  # GET /meseros
  # GET /meseros.json
  def index
    @meseros = Mesero.all
  end

  # GET /meseros/1
  # GET /meseros/1.json
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
  # POST /meseros.json
  def create
    @mesero = Mesero.new(mesero_params)

    respond_to do |format|
      if @mesero.save
        format.html { redirect_to @mesero, notice: 'Creado exitosamente.' }
        format.json { render :show, status: :created, location: @mesero }
      else
        format.html { render :new }
        format.json { render json: @mesero.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /meseros/1
  # PATCH/PUT /meseros/1.json
  def update
    respond_to do |format|
      if @mesero.update(mesero_params)
        format.html { redirect_to @mesero, notice: 'Actualizado exitosamente.' }
        format.json { render :show, status: :ok, location: @mesero }
      else
        format.html { render :edit }
        format.json { render json: @mesero.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /meseros/1
  # DELETE /meseros/1.json
  def destroy
    @mesero.destroy
    respond_to do |format|
      format.html { redirect_to meseros_url, notice: 'Mesero was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mesero
      @mesero = Mesero.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def mesero_params
      params.require(:mesero).permit(:nombre)
    end
end
