# frozen_string_literal: true

require 'integrations/izettle'

class IzettlePurchase < ApplicationRecord
  belongs_to :comanda, optional: true
  has_many :izettle_transactions

  CC_BRANDS = {
    'MASTERCARD' => 'fab fa-cc-mastercard',
    'VISA' => 'fab fa-cc-visa',
    'VISA_ELECTRON' => 'fab fa-cc-visa'
  }.freeze

  scope :del_dia, ->(dia) {
    where(purchased_at: dia.beginning_of_day..dia.end_of_day) if dia
  }
  scope :with_amount, ->(amount) {
    where(amount: amountsss) if amount.present?
  }

  def cc_icon
    CC_BRANDS[cc_brand] || 'fas fa-credit-card'
  end

  def link_comanda!
    self.comanda_id = Comanda
      .con_monto_total_tarjeta(amount)
      .del_dia(purchased_at.to_date)
      .where.not(
        id: IzettlePurchase.del_dia(purchased_at).pluck('comanda_id')
      ).take&.id
  end

  def self.sync(start_at, end_at)
    errored = []

    izettle_client = Izettle.new(Rails.application.credentials.izettle)

    izettle_client.purchases(start_at, end_at).each do |purchase|
      existing_id = IzettlePurchase.where(id: purchase['purchaseUUID1']).take&.id

      izettle_purchase = nil

      if existing_id.blank?
        # We only accept one payment
        payment = purchase['payments'].first
        purchased_at = Time.parse(purchase['timestamp'])
        amount = purchase['amount'].to_f / 100

        izettle_purchase = IzettlePurchase.new
        izettle_purchase.id = purchase['purchaseUUID1']
        izettle_purchase.amount = amount
        izettle_purchase.purchased_at = purchased_at
        izettle_purchase.payment_id = payment['uuid']
        izettle_purchase.cc_masked_number = payment['attributes']['maskedPan']
        izettle_purchase.cc_brand = payment['attributes']['cardType']
        izettle_purchase.link_comanda!
      else
        izettle_purchase = IzettlePurchase.find(existing_id)        
        izettle_purchase.link_comanda! if izettle_purchase.comanda.nil?
      end

      errored << izettle_purchase unless izettle_purchase.save
    end

    errored.blank? ? nil : errored
  end 
end
