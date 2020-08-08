# == Schema Information
#
# Table name: asistencias
#
#  id           :uuid             not null, primary key
#  mesero_id    :uuid
#  corte_id     :uuid
#  horas        :bigint
#  horas_extra  :bigint
#  retardo      :boolean          default(FALSE), not null
#  falta        :boolean          default(FALSE), not null
#  created_at   :datetime
#  updated_at   :datetime
#  hora_entrada :datetime
#  hora_salida  :datetime
#

class AsistenciasController < ApplicationController
  load_and_authorize_resource

  before_action :set_corte, only: [:index, :show, :new, :create]
  before_action :set_asistencia, only: [:show, :edit, :update, :destroy]
  before_action :set_meseros, only: [:new, :edit]

  # GET /asistencias
  def index
    @asistencias = @corte.asistencias.order(created_at: :desc).page(params[:page])
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
      redirect_to asistencias_path, notice: "¡#{@asistencia.mesero}, tu asistencia quedó registrada!"
    else
      render :new
    end
  end

  # PATCH/PUT /asistencias/1
  def update
    @asistencia.hora_salida = Time.current

    if @asistencia.update(asistencia_params)
      redirect_to asistencias_path, notice: "¡Que te vaya bien #{@asistencia.mesero}!"
    else
      render :edit
    end
  end

  # DELETE /asistencias/1
  def destroy
    @asistencia.discard

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

    def set_meseros
      @meseros = Mesero.por_asistir(current_sucursal).order(:nombre).map do |mesero|
        [mesero.nombre, mesero.id, {data: {'img-src' => mesero.public_avatar_url}}]
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def asistencia_params
      params.require(:asistencia).permit(:mesero_id, :corte_id, :horas, :horas_extra, :retardo, :falta)
    end
end
