class Api::MeserosController < Api::ApiController

  # POST /api/meseros
  def create
    @mesero = Mesero.new(mesero_params)

    if @mesero.save
      render :show, status: :created, location: @mesero
    else
      render json: @mesero.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/meseros/1
  def update
    @mesero = Mesero.find(params[:id])

    if @mesero.update(mesero_params)
      render :show, status: :ok, location: @mesero
    else
      render json: @mesero.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/meseros/1
  def destroy
    @mesero = Mesero.find(params[:id])

    @mesero.destroy

    head :no_content
  end

  private
    def mesero_params
      params.require(:mesero).permit(:id, :nombre, :created_at, :updated_at, :deleted_at)
    end
end
