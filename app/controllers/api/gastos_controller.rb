class Api::GastosController < Api::ApiController

  # POST /api/gastos
  def create
    @gasto = Gasto.new(gasto_params)

    if @gasto.save
      render :show, status: :created, location: @gasto
    else
      render json: @gasto.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/gastos/1
  def update
    @gasto = Gasto.find(params[:id])

    if @gasto.update(gasto_params)
      render :show, status: :ok, location: @gasto
    else
      render json: @gasto.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/gastos/1
  def destroy
    @gasto = Gasto.find(params[:id])

    @gasto.destroy

    head :no_content
  end

  private
    def gasto_params
      params.require(:gasto).permit(:id, :monto, :descripcion, :corte_id, :created_at, :updated_at, :deleted_at)
    end
end
