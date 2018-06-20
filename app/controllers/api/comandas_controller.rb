class Api::ComandasController < Api::ApiController

  # POST /api/comandas
  def create
    @comanda = Comanda.new(comanda_params)

    if @comanda.save
      render :show, status: :created, location: @comanda
    else
      render json: @comanda.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/comandas/1
  def update
    @comanda = Comanda.find(params[:id])

    if @comanda.update(comanda_params)
      render :show, status: :ok, location: @comanda
    else
      render json: @comanda.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/comandas/1
  def destroy
    @comanda = comanda.find(params[:id])

    @comanda.destroy

    head :no_content
  end

  private
  def comanda_params
    PrettyApi.with_nested_attributes(
      pretty_comanda_params,
      ordenes: [:extra_ordenes]
    )
  end

  def pretty_comanda_params
    params.require(:comanda).permit(
      :id,
      :mesa,
      :total,
      :descuento,
      :mesero_id,
      :comensales,
      :porcentaje_de_descuento,
      :created_at,
      :updated_at,
      :deleted_at,
      :venta,
      :closed_at,
      :pago_con_tarjeta,
      :corte_id,
      :propina,
      ordenes: [
        :id,
        :comanda_id,
        :precio_unitario,
        :articulo_id,
        :cantidad,
        :para_llevar,
        :created_at,
        :updated_at,
        :deleted_at,
        :_destroy,
        extra_ordenes: [
          :id,
          :extra_id,
          :orden_id,
          :created_at,
          :updated_at,
          :deleted_at,
          :_destroy
        ]
      ]
    )
  end
end
