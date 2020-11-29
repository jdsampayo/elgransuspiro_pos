# frozen_string_literal: true

class IzettleTransactionsController < ApplicationController
  # GET /izettle_transactions
  # GET /izettle_transactions.json
  def index
    order = params[:order] == 'ascendente' ? 'ASC' : 'DESC'

    @from_date = from_date(params)
    @to_date = to_date(params)

    if params[:izettle_purchase]
      izettle_purchase = IzettlePurchase.where(id: params[:izettle_purchase]).take

      if izettle_purchase
        @from_date = izettle_purchase.purchased_at.to_date
        @to_date = izettle_purchase.purchased_at.to_date + 7.days
      end
    end

    @izettle_transactions = IzettleTransaction
      .del_tipo(params[:type])
      .de_la_compra(params[:izettle_purchase])
      .where(transacted_at: @from_date.to_time.beginning_of_day..@to_date.to_time.end_of_day)
      .page(params[:page])
      .order("transacted_at #{order}")
  end

  # POST /izettle_transactions/sync
  # POST /izettle_transactions.json
  def sync
    @from_date = from_date(params).to_time.beginning_of_day
    @to_date = to_date(params).to_time.end_of_day

    IzettleTransaction.sync(@from_date, @to_date)

    redirect_to izettle_transactions_url, notice: 'Sincronizado correctamente.'
  end

private
  def from_date(params, yearly=false)
    return Date.parse(params[:start]) if params[:start]
    return Date.today.at_beginning_of_year if yearly

    Date.today.at_beginning_of_month
  end

  def to_date(params)
    return Date.parse(params[:end]) if params[:end]

    Date.today
  end
end
