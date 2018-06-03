class Api::AsistenciasController < Api::ApiController

  # POST /api/asistencias
  def create
    @asistencia = Asistencia.new(asistencia_params)

    if @asistencia.save
      render :show, status: :created, location: @asistencia
    else
      render json: @asistencia.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/asistencias/1
  def update
    @asistencia = Asistencia.find(params[:id])

    if @asistencia.update(asistencia_params)
      render :show, status: :ok, location: @asistencia
    else
      render json: @asistencia.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/asistencias/1
  def destroy
    @asistencia = Asistencia.find(params[:id])

    @asistencia.destroy

    head :no_content
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def asistencia_params
      params.require(:asistencia).permit(:id, :mesero_id, :corte_id, :horas, :horas_extra, :retardo, :falta, :created_at, :updated_at, :hora_entrada, :hora_salida)
    end
end
