class Api::ComandasController < Api::ApiController
  before_action :check_age

  # POST /api/comandas
  def create
    ordenes_params = comanda_params.delete("ordenes_attributes")
    @comanda = Comanda.new(comanda_params)

    ActiveRecord::Base.transaction do
      if @comanda.save!
        ordenes_params.each do |orden_params|
          extra_ordenes_params = orden_params.delete("extra_ordenes_attributes")
          extra_ordenes_params ||= []

          @orden = Orden.new(orden_params)

          if @orden.save!
            extra_ordenes_params.each do |extra_orden_params|
              @extra_orden = ExtraOrden.new(extra_orden_params)

              unless @extra_orden.save!
                render json: @extra_orden.errors, status: :unprocessable_entity
                return
              end
            end
          else
            render json: @orden.errors, status: :unprocessable_entity
            return
          end
        end
        render :show, status: :created, location: @comanda
      else
        render json: @comanda.errors, status: :unprocessable_entity
      end
    end
  end

  # PATCH/PUT /api/comandas/1
  def update
    @comanda = Comanda.find(params[:id])

    ordenes_params = comanda_params.delete("ordenes_attributes")

    old_ordenes_ids = @comanda.ordenes.pluck(:id)
    new_ordenes_ids = ordenes_params.map { |orden| orden["id"] }

    ActiveRecord::Base.transaction do
      if @comanda.update!(comanda_params)
        ordenes_params.each do |orden_params|
          extra_ordenes_params = orden_params.delete("extra_ordenes_attributes")
          extra_ordenes_params ||= []


          @orden = Orden.where(id: orden_params[:id]).first_or_initialize

          old_extra_ordenes_ids = @orden.extra_ordenes.pluck(:id)
          new_extra_ordenes_ids = extra_ordenes_params.map { |extra_orden| extra_orden["id"] }

          ExtraOrden.where(id: old_extra_ordenes_ids - new_extra_ordenes_ids).destroy_all

          if @orden.update!(orden_params)
            extra_ordenes_params.each do |extra_orden_params|
              @extra_orden = ExtraOrden.where(id: extra_orden_params[:id]).first_or_initialize

              unless @extra_orden.update!(extra_orden_params)
                render json: @extra_orden.errors, status: :unprocessable_entity
                return
              end
            end
          else
            render json: @orden.errors, status: :unprocessable_entity
            return
          end
        end
        Orden.where(id: old_ordenes_ids - new_ordenes_ids).destroy_all

        render :show, status: :ok, location: @comanda
      else
        render json: @comanda.errors, status: :unprocessable_entity
      end
    end
  end

  # DELETE /api/comandas/1
  def destroy
    @comanda = Comanda.find(params[:id])

    @comanda.destroy

    head :no_content
  end

  private

  def check_age
    created_at = comanda_params['created_at']

    if Time.parse(created_at) < 1.month.ago
      render json: { message: "Too old: #{created_at}" }, status: :created
    end

    true
  end

  def comanda_params
    @comanda_params ||= PrettyApi.with_nested_attributes(
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
      :es_pago_con_tarjeta,
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
