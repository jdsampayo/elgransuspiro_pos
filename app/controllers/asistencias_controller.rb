class AsistenciasController < ApplicationController
  before_action :set_asistencia, only: [:show, :edit, :update, :destroy]
  before_action :requiere_corte_actual, only: [:new, :edit]

  # GET /asistencias
  # GET /asistencias.json
  def index
    @q = Asistencia.joins(:corte).ransack(params[:q])
    @asistencias  = @q.result(distinct: true).order(corte_id: :desc).page(params[:page])
  end

  # GET /asistencias/1
  # GET /asistencias/1.json
  def show
  end

  # GET /asistencias/new
  def new
    @asistencia = Asistencia.new
    @asistencia.corte = Corte.actual
  end

  # GET /asistencias/1/edit
  def edit
  end

  # POST /asistencias
  # POST /asistencias.json
  def create
    @asistencia = Asistencia.new(asistencia_params)
    @asistencia.hora_entrada = Time.current

    respond_to do |format|
      if @asistencia.save
        format.html { redirect_to asistencias_path, notice: "¡#{@asistencia.mesero}, tu asistencia quedó registrada!" }
        format.json { render :show, status: :created, location: @asistencia }
      else
        format.html { render :new }
        format.json { render json: @asistencia.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /asistencias/1
  # PATCH/PUT /asistencias/1.json
  def update
    respond_to do |format|
      @asistencia.hora_salida = Time.current

      if @asistencia.update(asistencia_params)
        format.html { redirect_to asistencias_path, notice: "¡Que te vaya bien #{@asistencia.mesero}!." }
        format.json { render :show, status: :ok, location: @asistencia }
      else
        format.html { render :edit }
        format.json { render json: @asistencia.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /asistencias/1
  # DELETE /asistencias/1.json
  def destroy
    @asistencia.destroy
    respond_to do |format|
      format.html { redirect_to asistencias_url, notice: 'Asistencia was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_asistencia
      @asistencia = Asistencia.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def asistencia_params
      params.require(:asistencia).permit(:mesero_id, :corte_id, :horas, :horas_extra, :retardo, :falta)
    end
end
