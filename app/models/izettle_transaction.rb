# frozen_string_literal: true

require 'integrations/izettle'

class IzettleTransaction < ApplicationRecord
  belongs_to :izettle_purchase, optional: true

  enum transaction_type: %i[payout card_payment card_payment_fee card_refund card_payment_fee_refund failed_payout]

  validates_uniqueness_of :transacted_at, scope: [:transaction_type, :amount]

  TYPES = {
    payout: 'Transferencia a banco',
    card_payment: 'Pago a tarjeta',
    card_payment_fee: 'Comisión',
    card_refund: 'Reembolso de pago',
    card_payment_fee_refund: 'Reembolso de comisión',
    failed_payout: 'Pago fallido'
  }.freeze

  scope :del_dia, ->(dia) {
    where(transacted_at: dia.beginning_of_day..dia.end_of_day) if dia
  }
  scope :del_tipo, ->(tipo) {
    where(transaction_type: tipo) if tipo.present?
  }
  scope :de_la_compra, ->(compra) {
    where(izettle_purchase_id: compra) if compra.present?
  }

  def self.sync(start_at, end_at)
    errored = []

    izettle_client = Izettle.new(Rails.application.credentials.izettle)

    izettle_client.transactions(start_at, end_at).each do |transaction|
      payment_id = transaction['originatingTransactionUuid']

      amount = transaction['amount'].to_f / 100
      transacted_at = Time.parse(transaction['timestamp'])
      transaction_type = transaction['originatorTransactionType'].downcase.to_sym

      izettle_transaction = IzettleTransaction.where(
        amount: amount,
        transacted_at: transacted_at,
        transaction_type: transaction_type
      ).take

      if izettle_transaction.blank?
        izettle_transaction = IzettleTransaction.new
        izettle_transaction.transacted_at = transacted_at
        izettle_transaction.amount = amount
        izettle_transaction.transaction_type = transaction_type
        izettle_transaction.payment_id = payment_id
      end

      izettle_transaction.izettle_purchase = IzettlePurchase.where(payment_id: payment_id).take

      errored << izettle_transaction unless izettle_transaction.save
    end

    errored.blank? ? nil : errored
  end
end
