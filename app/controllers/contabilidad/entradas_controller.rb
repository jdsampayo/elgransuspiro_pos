module Contabilidad
  class EntradasController < ApplicationController
    def index
      order = params[:order] == 'ascendente' ? 'ASC' : 'DESC'

      @entries = Plutus::Entry

      unless params[:debit_account_id].blank?
        @entries = @entries.joins(:debit_accounts).
          where("plutus_accounts.id = #{params[:debit_account_id]}").distinct
      end

      unless params[:credit_account_id].blank?
        @entries = @entries.joins(:credit_accounts).
          where("plutus_accounts.id = #{params[:credit_account_id]}").distinct
      end

      @entries = @entries.where("description like ?", "%#{params[:description]}%").
        page(params[:page]).per(params[:limit]).order("date #{order}")

      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @entries }
        format.json  { render :json => @entries }
      end
    end
  end
end
