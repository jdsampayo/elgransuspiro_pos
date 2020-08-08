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
#  comensales              :bigint           default(1)
#  mesa                    :text             default("PARA LLEVAR")
#  created_at              :datetime
#  updated_at              :datetime
#  es_pago_con_tarjeta     :boolean          default(FALSE)
#  corte_id                :uuid
#  propina_con_efectivo    :decimal(, )      default(0.0)
#  porcentaje_de_descuento :bigint           default(0)
#  propina_con_tarjeta     :decimal(, )      default(0.0)
#  pago_con_efectivo       :decimal(, )      default(0.0)
#  pago_con_tarjeta        :decimal(, )      default(0.0)
#

class ComandasController < ApplicationController
  load_and_authorize_resource

  before_action :set_corte, only: [:index, :show, :new, :create]
  before_action :check_corte, only: [:new, :create]
  before_action :set_comanda, only: [:show, :edit, :update, :destroy, :pay, :close, :print]
  before_action :check_comanda, only: [:edit, :update, :destroy]

  # GET /comandas
  def index
    @comandas = @corte.comandas.kept.order(created_at: :desc)
    @gastos = Gasto.where(corte: @corte).kept

    @cerradas = @comandas.cerradas
    @abiertas = @comandas.abiertas

    @total_comandas_cerradas = @cerradas.sum(:total)

    @total_con_efectivo = @comandas.sum(:pago_con_efectivo)
    @total_con_tarjeta = @comandas.sum(:pago_con_tarjeta)

    @total_de_gastos = @gastos.sum(:monto)

    @corte.inicial ||= 0

    @caja = @corte.inicial + @total_comandas_cerradas - @total_con_tarjeta -
            @total_de_gastos

    @propinas_con_efectivo = @comandas.sum(:propina_con_efectivo)
    @propinas_con_tarjeta = @comandas.sum(:propina_con_tarjeta)

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
    @comanda.corte = @corte
    @comanda.descuento ||= 0
    @comanda.set_totales

    if @comanda.save
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
      message = 'Actualizada exitosamente.'
      redirect_to comandas_path(id: @comanda.id), notice: message
    else
      render :edit
    end
  end

  def switch
  end

  def print
    if cookies[:sucursal]
      ActionCable.server.broadcast("printer_channel:#{cookies[:sucursal]}", @comanda.to_text)
    else
      message = 'No está configurada la impresora en esta sucursal.'
      redirect_to comandas_url(id: @comanda.id), flash: { error: message }
      return
    end

    #@comanda.print_ticket

    redirect_to comandas_url(id: @comanda.id), notice: '¡Impresa!'
  rescue Errno::ENOENT
    message = '¡No se encuentra la impresora! Revisa que este conectada.'
    redirect_to comandas_url(id: @comanda.id), flash: { error: message }
  rescue StandardError => e
    redirect_to comandas_url(id: @comanda.id), flash: { error: e.message }
  end

  # DELETE /comandas/1
  def destroy
    @comanda.discard

    redirect_to comandas_url, notice: 'Eliminada.'
  end

  def pay
  end

  def close
    @comanda.closing = true
    @comanda.closed_at = Time.now

    if @comanda.update(close_comanda_params)
      @comanda.actualizar_conteos

      redirect_to comandas_path(id: @comanda.id), notice: '¡Cerrada!'
    else
      referer =  URI(request.referer).path.split('/').last
      render :pay if referer == 'pay'
      render :switch if referer == 'switch'
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_corte
    @corte = current_corte
  end

  def set_comanda
    @comanda = Comanda.find(params[:id])
  end

  def check_comanda
    return if @comanda.abierta?

    message = '¡Imposible! La comanda ya se encuentra cerrada.'
    redirect_to @comanda, notice: message
  end

  def check_corte
    return if @corte.abierto?

    message = '¡Imposible! El corte de este día ya está cerrado.'
    redirect_to comandas_path, notice: message
  end

  def comanda_params
    params.require(:comanda).permit(
      :mesa,
      :total,
      :descuento,
      :mesero_id,
      :comensales,
      :porcentaje_de_descuento,
      ordenes_attributes: ordenes_attributes
    )
  end

  def ordenes_attributes
    [
      :id,
      :articulo_id,
      :cantidad,
      :para_llevar,
      :_destroy,
      extra_ordenes_attributes: %i[id extra_id _destroy]
    ]
  end

  def close_comanda_params
    params.require(:comanda).permit(
      :es_pago_con_tarjeta,
      :propina_con_efectivo,
      :propina_con_tarjeta,
      :pago_con_efectivo,
      :pago_con_tarjeta
    )
  end
end
