class ArticulosController < ApplicationController
  load_and_authorize_resource

  before_action :set_articulo, only: [:show, :edit, :update, :destroy]

  # GET /articulos
  def index
    @categorias = Categoria.order(nombre: :asc)
  end

  # GET /articulos/1
  def show
    @articulos_por_dia = Orden.where(articulo_id: @articulo.id).
      group_by_day(:created_at, time_zone: false).sum(:cantidad)
  end

  # GET /articulos/new
  def new
    @articulo = Articulo.new
  end

  # GET /articulos/1/edit
  def edit
  end

  # POST /articulos
  def create
    @articulo = Articulo.new(articulo_params)

    if @articulo.save
      @articulo.syncronize_create
      redirect_to @articulo, notice: 'Creado exitosamente.'
    else
      render :new
    end
  end

  # PATCH/PUT /articulos/1
  def update
    if @articulo.update(articulo_params)
      @articulo.syncronize_update
      redirect_to @articulo, notice: 'Actualizado exitosamente.'
    else
      render :edit
    end
  end

  # DELETE /articulos/1
  def destroy
    @articulo.destroy
    @articulo.syncronize_destroy

    redirect_to articulos_url, notice: 'Eliminado.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_articulo
      @articulo = Articulo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def articulo_params
      params.require(:articulo).permit(:nombre, :precio, :categoria_id, desechable_ids: [])
    end
end
