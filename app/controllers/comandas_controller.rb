# == Schema Information
#
# Table name: comandas
#
#  id                      :uuid             not null, primary key
#  venta                   :decimal(, )      default(0.0)
#  descuento               :decimal(, )      default(0.0)
#  total                   :decimal(, )      default(0.0)
#  mesero_id               :uuid
#  deleted_at              :datetime
#  closed_at               :datetime
#  comensales              :bigint(8)        default(1)
#  mesa                    :text             default("PARA LLEVAR")
#  created_at              :datetime
#  updated_at              :datetime
#  pago_con_tarjeta        :boolean          default(FALSE)
#  corte_id                :uuid
#  propina                 :decimal(, )      default(0.0)
#  porcentaje_de_descuento :bigint(8)        default(0)
#

class ComandasController < ApplicationController
  load_and_authorize_resource

  before_action :set_comanda, only: [:show, :edit, :update, :destroy, :pay, :close, :print]
  before_action :check_comanda, only: [:edit, :update, :destroy]
  before_action :check_corte, only: [:new, :create]
  before_action :requiere_corte_actual, only: [:index]

  # GET /comandas
  def index
    @corte = Corte.actual
    @comandas = @corte.comandas.order(created_at: :desc)
    @gastos = Gasto.where(corte: @corte)

    @cerradas = @comandas.cerradas
    @abiertas = @comandas.abiertas

    @con_tarjeta = @comandas.con_tarjeta
    @con_efectivo = @comandas.con_efectivo

    @total_comandas_cerradas = @cerradas.sum(:total)
    @total_con_tarjeta = @con_tarjeta.sum(:total)

    @total_de_gastos = @gastos.sum(:monto)

    @caja = @corte.inicial + @total_comandas_cerradas - @total_con_tarjeta -
            @total_de_gastos

    @propinas = @comandas.sum(:propina)
    @total_de_ventas = @comandas.sum(:total)

    @id = params[:id]
  end

  # GET /comandas/1
  def show
  end

  # GET /comandas/new
  def new
    @comanda = Comanda.new
    1.times { @comanda.ordenes.build }
  end

  # GET /comandas/1/edit
  def edit
    redirect_to @comanda unless @comanda.abierta?
  end

  # POST /comandas
  def create
    @comanda = Comanda.new(comanda_params)
    @comanda.corte = Corte.actual
    @comanda.descuento ||= 0
    @comanda.set_totales

    if @comanda.save
      @comanda.syncronize_create
      message = '¡La comanda fue creada exitosamente!'
      redirect_to comandas_path(id: @comanda.id), success: message
    else
      render :new
    end
  end

  # PATCH/PUT /comandas/1
  def update
    if @comanda.update(comanda_params)
      @comanda.set_totales
      @comanda.save
      @comanda.syncronize_update
      message = 'Actualizada exitosamente.'
      redirect_to comandas_path(id: @comanda.id), notice: message
    else
      render :edit
    end
  end

  def switch
    @comanda.switch_payment_method!
    @comanda.syncronize_update

    message = '¡Se intercambió el método de pago!'
    redirect_to comandas_url(id: @comanda.id), notice: message
  end

  def print
    @comanda.print_ticket

    redirect_to comandas_url(id: @comanda.id), notice: '¡Impresa!'
  rescue Errno::ENOENT
    message = '¡No se encuentra la impresora! Revisa que este conectada.'
    redirect_to comandas_url(id: @comanda.id), flash: { error: message }
  rescue => e
    redirect_to comandas_url(id: @comanda.id), flash: { error: e.message }
  end

  # DELETE /comandas/1
  def destroy
    @comanda.destroy
    @comanda.syncronize_destroy

    redirect_to comandas_url, notice: 'Eliminada.'
  end

  def pay
  end

  def close
    @comanda.closed_at = Time.now
    if @comanda.update(close_comanda_params)
      @comanda.syncronize_update
      @comanda.actualizar_conteos

      redirect_to comandas_url, notice: '¡Cerrada!'
    else
      render :edit
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_comanda
    @comanda = Comanda.find(params[:id])
  end

  def check_comanda
    message = '¡Imposible! La comanda ya se encuentra cerrada.'
    redirect_to @comanda, notice: message unless @comanda.abierta?
  end

  def check_corte
    if Corte.actual.nil? || Corte.actual.cerrado?
      message = '¡Imposible! El corte de este día ya está cerrado.'
      redirect_to comandas_path, notice: message
    end
  end

  def comanda_params
    params.require(:comanda).permit(
      :mesa,
      :total,
      :descuento,
      :mesero_id,
      :comensales,
      :porcentaje_de_descuento,
      ordenes_attributes: [
        :id,
        :articulo_id,
        :cantidad,
        :para_llevar,
        :_destroy,
        extra_ordenes_attributes: %i[id extra_id _destroy]
      ]
    )
  end

  def close_comanda_params
    params.require(:comanda).permit(:pago_con_tarjeta, :propina)
  end
end
