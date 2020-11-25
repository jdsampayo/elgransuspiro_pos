# frozen_string_literal: true

class IzettlePurchase < ApplicationRecord
  belongs_to :comanda, optional: true

  CC_BRANDS = {
    'MASTERCARD' => 'fab fa-cc-mastercard',
    'VISA' => 'fab fa-cc-visa',
    'VISA_ELECTRON' => 'fab fa-cc-visa'
  }.freeze

  def cc_icon
    CC_BRANDS[cc_brand] || 'fas fa-credit-card'
  end

  def link_comanda!
    self.comanda = Comanda.joins(:corte)
      .where('comandas.pago_con_tarjeta + comandas.propina_con_tarjeta = ?', amount)
      .where('cortes.dia' => purchased_at.to_date).where.not(
        'comandas.id' => IzettlePurchase.where(
          purchased_at: purchased_at.beginning_of_day..purchased_at.end_of_day
        ).pluck(:id)
      ).take
  end
end
