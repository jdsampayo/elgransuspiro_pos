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
      params.require(:comanda).permit(:id, :nombre, :precio, :categoria_id, :created_at, :updated_at, :deleted_at, desechable_ids: [])
    end
end
