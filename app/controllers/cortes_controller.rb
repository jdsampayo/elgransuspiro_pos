# == Schema Information
#
# Table name: cortes
#
#  id                 :uuid             not null, primary key
#  dia                :date
#  inicial            :decimal(, )      default(0.0)
#  ventas             :decimal(, )      default(0.0)
#  sum_gastos         :decimal(, )      default(0.0)
#  total              :decimal(, )      default(0.0)
#  siguiente_dia      :decimal(, )      default(0.0)
#  sobre              :decimal(, )      default(0.0)
#  closed_at          :datetime
#  created_at         :datetime
#  updated_at         :datetime
#  pagos_con_tarjeta  :decimal(, )      default(0.0)
#  pagos_con_efectivo :decimal(, )      default(0.0)
#  deleted_at         :datetime
#  propinas           :decimal(, )
#

class CortesController < ApplicationController
  load_and_authorize_resource

  before_action :set_corte, only: [:show, :edit, :update, :destroy]

  # GET /cortes
  def index
    @cortes = Corte.order(dia: :desc).page params[:page]

    date = Date.today.beginning_of_week

    @semanal = [
      {
        name: "Semana actual",
        data: Corte.de_la_semana(date)
      }
    ]

    (1..9).each do |index|
      @semanal <<
        {
          name: "Semana -#{index}",
          data: Corte.de_la_semana(date - index.week)
        }
    end

    por_semana_query = Corte.unscoped.group_by_week(:dia, last: 10)
    @por_semana = [
      {
        name: "Ventas",
        data: por_semana_query.sum(:ventas)
      }
    ]
  end

  def propinas
    @propinas = Corte.page(params[:page]).pluck(:dia, :propinas)
    @cortes = Corte.includes(:asistencias).page params[:page]
  end

  # GET /cortes/1
  def show
    @corte.set_subtotals
  end

  # GET /cortes/new
  def new
    @corte = Corte.new
  end

  # GET /cortes/1/edit
  def edit
    @corte.set_subtotals
  end

  # POST /cortes
  # POST /cortes.json
  def create
    @corte = Corte.new(corte_params)

    if @corte.save
      redirect_to comandas_path, notice: 'El corte se creó exitosamente.'
    else
      render :new
    end
  end

  # PATCH/PUT /cortes/1
  def update
    if @corte.comandas_abiertas.kept.present?
      redirect_to edit_corte_path(@corte), warning: 'Por favor, primero cierra las comandas abiertas'
    elsif @corte.update(corte_params)
      @corte.cerrar

      redirect_to @corte, notice: 'El corte se cerró correctamente.'
    else
      render :edit
    end
  end

  # DELETE /cortes/1
  def destroy
    @corte.discard
    redirect_to cortes_url, notice: 'El corte se eliminó correctamente.'
  end

  private
    def set_corte
      @corte = Corte.find(params[:id])
    end

    def corte_params
      params.require(:corte).permit(
        :dia,
        :inicial,
        :ventas,
        :gastos,
        :total,
        :siguiente_dia,
        :sobre,
        :propinas,
        :pagos_con_efectivo,
        :propinas_con_efectivo,
        :subtotal,
        :pagos_con_tarjeta,
        :propinas_con_tarjeta,
        :sum_gastos,
        :caja,
        :sobre_sin_propinas
      )
    end
end
