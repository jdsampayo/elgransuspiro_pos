# == Schema Information
#
# Table name: asistencias
#
#  id           :uuid             not null, primary key
#  mesero_id    :uuid
#  corte_id     :uuid
#  horas        :bigint(8)
#  horas_extra  :bigint(8)
#  retardo      :boolean
#  falta        :boolean
#  created_at   :datetime
#  updated_at   :datetime
#  hora_entrada :datetime
#  hora_salida  :datetime
#

class AsistenciasController < ApplicationController
  load_and_authorize_resource

  before_action :set_corte, only: [:index, :show, :new, :create]
  before_action :set_asistencia, only: [:show, :edit, :update, :destroy]

  # GET /asistencias
  def index
    @q = Asistencia.includes([:corte, :mesero]).ransack(params[:q])
    @asistencias = @q.result(distinct: true).order(created_at: :desc).page(params[:page])
  end

  # GET /asistencias/1
  def show
  end

  # GET /asistencias/new
  def new
    @asistencia = Asistencia.new
    @asistencia.corte = @corte
  end

  # GET /asistencias/1/edit
  def edit
  end

  # POST /asistencias
  def create
    @asistencia = Asistencia.new(asistencia_params)
    @asistencia.hora_entrada = Time.current

    if @asistencia.save
      @asistencia.syncronize_create

      redirect_to asistencias_path, notice: "¡#{@asistencia.mesero}, tu asistencia quedó registrada!"
    else
      render :new
    end
  end

  # PATCH/PUT /asistencias/1
  def update
    @asistencia.hora_salida = Time.current

    if @asistencia.update(asistencia_params)
      @asistencia.syncronize_update

      redirect_to asistencias_path, notice: "¡Que te vaya bien #{@asistencia.mesero}!"
    else
      render :edit
    end
  end

  # DELETE /asistencias/1
  def destroy
    @asistencia.destroy
    @asistencia.syncronize_destroy

    redirect_to asistencias_url, notice: 'Asistencia was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_corte
      @corte = current_corte
    end

    def set_asistencia
      @asistencia = Asistencia.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def asistencia_params
      params.require(:asistencia).permit(:mesero_id, :corte_id, :horas, :horas_extra, :retardo, :falta)
    end
end
