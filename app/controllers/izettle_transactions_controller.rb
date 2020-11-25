require 'integrations/izettle'

class IzettleTransactionsController < ApplicationController
  # GET /izettle_transactions
  # GET /izettle_transactions.json
  def index
    @izettle_transactions = IzettleTransaction.page(params[:page])
  end

  # POST /izettle_transactions/sync
  # POST /izettle_transactions.json
  def sync
    izettle_client = Izettle.new(Rails.application.credentials.izettle)

    start_at = (Time.now - 2.months).beginning_of_month
    end_at = (Time.now - 2.months).end_of_month

    izettle_transactions = izettle_client.transactions(start_at, end_at)

    izettle_payment_transactions = izettle_transactions.select do |trx|
      trx['originatorTransactionType'] == 'CARD_PAYMENT'
    end
    izettle_fee_transactions = izettle_transactions.select do |trx|
      trx['originatorTransactionType'] == 'CARD_PAYMENT_FEE'
    end
    izettle_payout_transactions = izettle_transactions.select do |trx|
      trx['originatorTransactionType'] == 'PAYOUT'
    end

    puts izettle_payment_transactions

    IzettleTransaction.transaction do
      izettle_transactions.each do |transaction|
        izettle_transaction = IzettleTransaction.new
        izettle_transaction.transacted_at = Time.parse(transaction['timestamp'])
        izettle_transaction.amount = transaction['amount'].to_f / 100
        izettle_transaction.transaction_type = transaction['originatorTransactionType'].downcase.to_sym
        izettle_transaction.payment_id = transaction['originatingTransactionUuid']
        izettle_transaction.link_purchase!

        izettle_transaction.save
      end
    end

    redirect_to izettle_transactions_url, notice: 'Sincronizado correctamente.'
  end
end
