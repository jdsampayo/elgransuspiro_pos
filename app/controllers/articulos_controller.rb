# == Schema Information
#
# Table name: articulos
#
#  id           :uuid             not null, primary key
#  nombre       :text
#  precio       :decimal(, )      default(0.0)
#  created_at   :datetime
#  updated_at   :datetime
#  categoria_id :uuid
#  deleted_at   :datetime
#

class ArticulosController < ApplicationController
  load_and_authorize_resource

  before_action :set_articulo, only: [:show, :edit, :update, :destroy]

  # GET /articulos
  def index
    @categorias = Categoria.order(nombre: :asc)
  end

  def report
    @best_products = Orden
      .group(:articulo_id)
      .select('articulo_id SUM(cantidad) as total')
      .order('total desc')
  end

  # GET /articulos/1
  def show
    @products_per_day = Orden
      .where(articulo_id: @articulo.id)
      .group_by_month(:created_at, time_zone: false)
      .sum(:cantidad)

    orders = Orden.joins(:comanda).where(articulo_id: @articulo.id).order(created_at: :desc)

    @first_sale = orders.last
    @last_sale = orders.first
    @total = orders.sum(:cantidad)
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
    @articulo.discard
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
      params.require(:articulo).permit(:nombre, :precio, :categoria_id, desechable_ids: [], extra_ids: [])
    end
end
