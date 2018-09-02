module Contabilidad
  class EntradasController < ApplicationController
    authorize_resource class: false

    def index
      order = params[:order] == 'ascendente' ? 'ASC' : 'DESC'

      @entries = Plutus::Entry

      unless params[:debit_account_id].blank?
        @entries = @entries.joins(:debit_accounts).
          where("plutus_accounts.id = '#{params[:debit_account_id]}'").distinct
      end

      unless params[:credit_account_id].blank?
        @entries = @entries.joins(:credit_accounts).
          where("plutus_accounts.id = '#{params[:credit_account_id]}'").distinct
      end

      @entries = @entries.where("description like ?", "%#{params[:description]}%").
        page(params[:page]).per(params[:limit]).order("date #{order}")

      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @entries }
        format.json  { render :json => @entries }
      end
    end

    def new
      @entrada = Entrada.new
      @entrada.date = Date.today.to_s
      @entrada.description = "Movimientos del día #{Date.today.to_s}"
    end

    def create
      @entrada = Entrada.new(entrada_params)
      if @entrada.valid?
        status, mensajes = @entrada.registro_contable

        if status
          redirect_to contabilidad_entradas_path, notice: 'Creada exitosamente.'
        else
          @entrada.errors.add(:base, mensajes)
          render :new
        end
      else
        render :new
      end
    end

    def entrada_params
      params.require(:entrada).permit(:date, :description, debits_attributes: [:account_id, :amount], credits_attributes: [:account_id, :amount])
    end
  end
end
