module Contabilidad
  class CuentasController < ApplicationController
    authorize_resource class: false

    def index
      @accounts = Plutus::Account.all

      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render xml: @accounts }
        format.json  { render json: @accounts }
      end
    end

    def new
      @type = params[:type].pluralize
      @add_delete_action = true
      @account = Plutus::Account.new
    end

    def show
      @account = Plutus::Account.find(params[:id])

      @from_date = from_date(params, true)
      @to_date = to_date(params)

      entries = Plutus::Entry.includes(:accounts)
        .with_account(@account.id)
        .where(date: @from_date..@to_date)
        .order(date: :asc)

      @debits = []
      @credits = []
      entries.each do |entry|
        entry.debit_amounts.each do |amount|
          next unless amount.account == @account
          @debits << {
            amount: amount.amount,
            date: entry.date,
            description: entry.description
          }
        end
        entry.credit_amounts.each do |amount|
          next unless amount.account == @account
          @credits << {
            amount: amount.amount,
            date: entry.date,
            description: entry.description
          }
        end
      end

      @debits_sum = @debits.sum { |h| h[:amount] }
      @credits_sum = @credits.sum { |h| h[:amount] }
      @balance = @debits_sum - @credits_sum

      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => entries }
        format.json  { render :json => entries }
      end
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
end
