class Api::CortesController < Api::ApiController
  # POST /api/cortes
  def create
    @corte = Corte.new(corte_params)

    if @corte.save
      render :show, status: :created, location: @corte
    else
      render json: @corte.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/cortes/1
  def update
    @corte = Corte.find(params[:id])

    if @corte.update(corte_params)
      @corte.finalize_comandas
      @corte.create_registro_contable

      render :show, status: :ok, location: @corte
    else
      render json: @corte.errors, status: :unprocessable_entity
    end
  end

  private
    def corte_params
      params.require(:corte).permit(
        :id,
        :dia,
        :inicial,
        :ventas,
        :gastos,
        :total,
        :siguiente_dia,
        :sobre,
        :closet_at,
        :created_at,
        :updated_at,
        :deleted_at,
        :pagos_con_tarjeta,
        :pagos_con_efectivo,
        :propinas
      )
    end
end
