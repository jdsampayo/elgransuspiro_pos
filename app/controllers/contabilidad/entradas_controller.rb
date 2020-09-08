module Contabilidad
  class EntradasController < ApplicationController
    authorize_resource class: false

    def index
      order = params[:order] == 'ascendente' ? 'ASC' : 'DESC'

      @entries = Plutus::Entry

      @from_date = from_date(params, true)
      @to_date = to_date(params)

      unless params[:debit_account_id].blank?
        @entries = @entries.joins(:debit_accounts).
          where("plutus_accounts.id = '#{params[:debit_account_id]}'").distinct
      end

      unless params[:credit_account_id].blank?
        @entries = @entries.joins(:credit_accounts).
          where("plutus_accounts.id = '#{params[:credit_account_id]}'").distinct
      end

      @entries = @entries.where("description like ?", "%#{params[:description]}%").
        page(params[:page]).per(params[:limit]).where(date: @from_date..@to_date).
        order("date #{order}")

      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @entries }
        format.json  { render :json => @entries }
      end
    end

    def new
      shortcut = params[:shortcut]&.to_sym || :plain

      @entrada = Entrada.new
      @entrada.date = Date.today.to_s

      initial = Entrada::SHORTCUTS[shortcut]
      @entrada.description = initial[:description]
      @entrada.image = initial[:image]
      @entrada.debits_attributes = initial[:debits].each_with_index.map do |account, index|
        [ Time.now.to_i.to_s + '0' + index.to_s, { account_id: account } ]
      end.to_h
      @entrada.credits_attributes = initial[:credits].each_with_index.map do |account, index|
        [ Time.now.to_i.to_s + '1' + index.to_s, { account_id: account } ]
      end.to_h

      puts @entrada.debits_attributes
    end

    def create
      @entrada = Entrada.new(entrada_params)
      @entrada.debits_attributes&.delete_if { |id, entry| entry[:amount].to_i.zero? }
      @entrada.credits_attributes&.delete_if { |id, entry| entry[:amount].to_i.zero? }

      if @entrada.save
        redirect_to contabilidad_entradas_path, notice: 'Creada exitosamente.'
      else
        initial = Entrada::SHORTCUTS[:plain]

        unless @entrada.debits_attributes&.present?
          @entrada.debits_attributes = initial[:debits].each_with_index.map do |account, index|
            [ Time.now.to_i.to_s + '0' + index.to_s, { account_id: account } ]
          end.to_h
        end

        unless @entrada.credits_attributes&.present?
          @entrada.credits_attributes = initial[:credits].each_with_index.map do |account, index|
            [ Time.now.to_i.to_s + '1' + index.to_s, { account_id: account } ]
          end.to_h
        end

        render :new
      end
    end

    def destroy
      @entry = Plutus::Entry.find(params[:id])

      if @entry
        @entry.delete
        Plutus::Amount.where(entry_id: params[:id]).delete_all

        redirect_to contabilidad_entradas_url, notice: 'Eliminada.'
      else
        redirect_to contabilidad_entradas_url, notice: 'El registro no existe.'
      end
    end

    def entrada_params
      params.require(:entrada).permit(:date, :description, debits_attributes: [:account_id, :amount], credits_attributes: [:account_id, :amount])
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
