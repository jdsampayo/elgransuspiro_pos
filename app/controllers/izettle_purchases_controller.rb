require 'integrations/izettle'

class IzettlePurchasesController < ApplicationController
  # GET /izettle_purchases
  # GET /izettle_purchases.json
  def index
    if current_user.admin? || current_user.manager?
      @izettle_purchases = IzettlePurchase.includes(:comanda).page(params[:page])
    elsif current_user.waitress?
      @izettle_purchases = IzettlePurchase.includes(:comanda).where('comandas.corte_id' => current_corte).page(params[:page])
    end
  end

  # POST /izettle_purchases/sync
  # POST /izettle_purchases.json
  def sync
    izettle_client = Izettle.new(Rails.application.credentials.izettle)

    start_at = (Time.now - 2.months).beginning_of_month
    end_at = (Time.now - 2.months).end_of_month

    izettle_purchases = izettle_client.purchases(start_at, end_at)

    puts izettle_purchases

    izettle_purchases.each do |purchase|
      next if IzettlePurchase.find(purchase['purchaseUUID1']).present?

      izettle_purchase = IzettlePurchase.new
      izettle_purchase.id = purchase['purchaseUUID1']
      izettle_purchase.amount = purchase['amount'].to_f / 100
      izettle_purchase.purchased_at = Time.parse(purchase['timestamp'])
      payment = purchase['payments'].first
      izettle_purchase.payment_id = payment['uuid']
      izettle_purchase.cc_masked_number = payment['attributes']['maskedPan']
      izettle_purchase.cc_brand = payment['attributes']['cardType']
      izettle_purchase.link_comanda!

      if izettle_purchase.save
        puts "Guardada #{izettle_purchase.id}"
      else
        puts "Error #{purchase['purchaseUUID1']}"
      end
    end

    redirect_to izettle_purchases_url, notice: 'Sincronizado correctamente.'
  end
end
