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
    # Never trust parameters from the scary internet, only allow the white list through.
    def comanda_params
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
        ordenes_attributes: [
          :id,
          :articulo_id,
          :cantidad,
          :para_llevar,
          :created_at,
          :updated_at,
          :deleted_at,
          :_destroy,
          extra_ordenes_attributes: [
            :id,
            :extra_id,
            :created_at,
            :updated_at,
            :deleted_at,
            :_destroy
          ]
        ]
      )
    end
end
