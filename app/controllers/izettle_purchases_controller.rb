# frozen_string_literal: true

class IzettlePurchasesController < ApplicationController
  # GET /izettle_purchases
  # GET /izettle_purchases.json
  def index
    order = params[:order] == 'ascendente' ? 'ASC' : 'DESC'

    @from_date = from_date(params)
    @to_date = to_date(params)
    @from_date = @to_date = Date.today if current_user.waitress?

    @izettle_purchases = IzettlePurchase
      .includes(:comanda)
      .where(purchased_at: @from_date.to_time.beginning_of_day..@to_date.to_time.end_of_day)
      .page(params[:page])
      .order("purchased_at #{order}")
  end

  # POST /izettle_purchases/sync
  # POST /izettle_purchases.json
  def sync
    start_at = Time.now.beginning_of_month
    end_at = Time.now.end_of_month

    IzettlePurchase.sync(start_at, end_at)

    redirect_to izettle_purchases_url, notice: 'Sincronizado correctamente.'
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
