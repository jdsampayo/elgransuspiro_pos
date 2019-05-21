module Contabilidad
  class ReportesController < ApplicationController
    authorize_resource class: false

    def balance_sheet
      first_entry = Plutus::Entry.order('date ASC').first
      @from_date = first_entry ? first_entry.date : Date.today
      @to_date = params[:date] ? Date.parse(params[:date]) : Date.today
      @assets = Plutus::Asset.all
      @liabilities = Plutus::Liability.all
      @equity = Plutus::Equity.all

      respond_to do |format|
        format.html # index.html.erb
      end
    end

    def income_statement
      @from_date = params[:from_date] ? Date.parse(params[:from_date]) : Date.today.at_beginning_of_month
      @to_date = params[:to_date] ? Date.parse(params[:to_date]) : Date.today
      @revenues = Plutus::Revenue.all
      @expenses = Plutus::Expense.all

      respond_to do |format|
        format.html # index.html.erb
      end
    end

    def monthly
      time = 14.months.ago
      @from_date = time.beginning_of_month.to_date
      @to_date = time.end_of_month.to_date

      @assets = Plutus::Asset.all
      @liabilities = Plutus::Liability.all
      @equity = Plutus::Equity.all
      @revenues = Plutus::Revenue.all
      @expenses = Plutus::Expense.all

      time = 9.months.ago
      first_fortnight = time.beginning_of_month#Time.current
      second_fortnight = time.end_of_month#Time.current

      @from_date = beginning_of_fortnight(first_fortnight).to_date
      @to_date = end_of_fortnight(first_fortnight).to_date

      @second_from_date = beginning_of_fortnight(second_fortnight).to_date
      @second_to_date = end_of_fortnight(second_fortnight).to_date


      respond_to do |format|
        format.html # index.html.erb
      end
    end
  end
end
