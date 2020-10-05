module Contabilidad
  class EntradasController < ApplicationController
    authorize_resource class: false

    def index
      order = params[:order] == 'ascendente' ? 'ASC' : 'DESC'

      @entries = Plutus::Entry

      @from_date = from_date(params)
      @to_date = to_date(params)

      @entries = @entries.includes(:accounts)
        .with_account(params[:account_id])
        .where(date: @from_date..@to_date)
        .with_description(params[:description])
        .page(params[:page])
        .per(params[:limit])
        .order("date #{order}")

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
        @entrada.errored = true

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

    def edit
      @entrada = Entrada.find(params[:id])
      @entry = Plutus::Entry.find(params[:id])
    end

    def update
      @entrada = Entrada.find(params[:id])

      if @entrada.update(entrada_params)
        redirect_to contabilidad_entradas_url, notice: 'Actualizadas.'
      else
        redirect_to contabilidad_entradas_url, notice: 'Imposible Editar.'
      end
    end

    def destroy
      @entrada = Entrada.find(params[:id])
      @entrada.delete

      redirect_to contabilidad_entradas_url, notice: 'Eliminada.'
    end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def entrada_params
      params.require(:entrada).permit(:date, :description, debits_attributes: [:account_id, :amount], credits_attributes: [:account_id, :amount])
    end

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
