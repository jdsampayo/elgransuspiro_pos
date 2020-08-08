# == Schema Information
#
# Table name: comandas
#
#  id                      :uuid             not null, primary key
#  venta                   :decimal(, )      default(0.0)
#  descuento               :decimal(, )      default(0.0)
#  total                   :decimal(, )      default(0.0)
#  mesero_id               :uuid
#  deleted_at              :datetime
#  closed_at               :datetime
#  comensales              :bigint           default(1)
#  mesa                    :text             default("PARA LLEVAR")
#  created_at              :datetime
#  updated_at              :datetime
#  es_pago_con_tarjeta     :boolean          default(FALSE)
#  corte_id                :uuid
#  propina_con_efectivo    :decimal(, )      default(0.0)
#  porcentaje_de_descuento :bigint           default(0)
#  propina_con_tarjeta     :decimal(, )      default(0.0)
#  pago_con_efectivo       :decimal(, )      default(0.0)
#  pago_con_tarjeta        :decimal(, )      default(0.0)
#

module ComandasHelper
end
