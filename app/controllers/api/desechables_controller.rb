class Api::DesechablesController < Api::ApiController

  # POST /api/desechables
  def create
    @desechable = Desechable.new(desechable_params)

    if @desechable.save
      render :show, status: :created, location: @desechable
    else
      render json: @desechable.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/desechables/1
  def update
    @desechable = Desechable.find(params[:id])

    if @desechable.update(desechable_params)
      render :show, status: :ok, location: @desechable
    else
      render json: @desechable.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/desechables/1
  def destroy
    @desechable = Desechable.find(params[:id])

    @desechable.destroy

    head :no_content
  end

  private
    def desechable_params
      params.require(:desechable).permit(:id, :nombre, :en_bodega, :cantidad, :costo_unitario, :limite, :created_at, :updated_at, :deleted_at)
    end
end
