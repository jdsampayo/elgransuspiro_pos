class Api::ArticulosController < Api::ApiController

  # POST /api/articulos
  def create
    @articulo = Articulo.new(articulo_params)

    if @articulo.save
      render :show, status: :created, location: @articulo
    else
      render json: @articulo.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/articulos/1
  def update
    @articulo = Articulo.find(params[:id])

    if @articulo.update(articulo_params)
      render :show, status: :ok, location: @articulo
    else
      render json: @articulo.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/articulos/1
  def destroy
    @articulo = Articulo.find(params[:id])

    @articulo.destroy

    head :no_content
  end

  private
    def articulo_params
      params.require(:articulo).permit(:id, :nombre, :precio, :categoria_id, :created_at, :updated_at, :deleted_at, desechable_ids: [])
    end
end
