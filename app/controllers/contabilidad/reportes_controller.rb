module Contabilidad
  class ReportesController < ApplicationController
    authorize_resource class: false

    def balance_sheet
      @from_date = from_date(params, true)
      @to_date = to_date(params)

      @assets = Plutus::Asset.all
      @liabilities = Plutus::Liability.all
      @equity = Plutus::Equity.all

      respond_to do |format|
        format.html # index.html.erb
      end
    end

    def income_statement
      @from_date = from_date(params, true)
      @to_date = to_date(params)

      @revenues = Plutus::Revenue.all
      @expenses = Plutus::Expense.all

      respond_to do |format|
        format.html # index.html.erb
      end
    end

    def cash_flow
      @from_date = params[:date] ? Date.parse(params[:date] + "-01-01") : Date.today.beginning_of_year

      @initials = [Cuenta.caja_chica, Cuenta.caja_fuerte, Cuenta.banco]
      @revenues = Plutus::Revenue.all
      @expenses = Plutus::Expense.all
      @liabilities = Plutus::Liability.all
      @equities = Plutus::Equity.all
    end

    def monthly
      time = params[:date] ? Date.parse(params[:date] + "-01") : Date.today.beginning_of_month

      first_fortnight = time.beginning_of_month
      second_fortnight = time.end_of_month

      @from_date = beginning_of_fortnight(first_fortnight).to_date
      @to_date = end_of_fortnight(first_fortnight).to_date

      @initial_cash = Cuenta.caja_fuerte.balance(from_date: Cuenta::EPOCH, to_date: @from_date - 1.day)
      @initial_bank = Cuenta.banco.balance(from_date: Cuenta::EPOCH, to_date: @from_date - 1.day)

      @second_from_date = beginning_of_fortnight(second_fortnight).to_date
      @second_to_date = end_of_fortnight(second_fortnight).to_date

      @second_cash = Cuenta.caja_fuerte.balance(from_date: Cuenta::EPOCH, to_date: @second_from_date - 1.day)
      @second_bank = Cuenta.banco.balance(from_date: Cuenta::EPOCH, to_date: @second_from_date - 1.day)

      respond_to do |format|
        format.html # index.html.erb
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
