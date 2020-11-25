# frozen_string_literal: true

class IzettleTransaction < ApplicationRecord
  belongs_to :izettle_purchase, optional: true

  enum transaction_type: %i[payout card_payment card_payment_fee card_refund card_payment_fee_refund]

  validates_uniqueness_of :transacted_at, scope: [:transaction_type, :amount]

  PAYMENT_TYPES = {
    payout: 'Transferencia a banco',
    card_payment: 'Pago a tarjeta',
    card_payment_fee: 'Comisión',
    card_refund: 'Reembolso de pago',
    card_payment_fee_refund: 'Reembolso de comisión'
  }.freeze

  def link_purchase!
    self.izettle_purchase = IzettlePurchase.where(payment_id: payment_id).take
  end
end
