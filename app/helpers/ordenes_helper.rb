# == Schema Information
#
# Table name: ordenes
#
#  id              :uuid             not null, primary key
#  articulo_id     :uuid
#  comanda_id      :uuid
#  cantidad        :bigint(8)
#  precio_unitario :decimal(, )      default(0.0)
#  created_at      :datetime
#  updated_at      :datetime
#  para_llevar     :boolean
#  deleted_at      :datetime
#

module OrdenesHelper
end
