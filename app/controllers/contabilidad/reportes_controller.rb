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
      time = params[:date] ? Date.parse(params[:date]) : Date.today

      first_fortnight = time.beginning_of_month
      second_fortnight = time.end_of_month

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
