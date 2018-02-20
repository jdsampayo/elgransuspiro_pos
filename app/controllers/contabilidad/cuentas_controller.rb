module Contabilidad

  class CuentasController < ApplicationController
    def index
      @accounts = Plutus::Account.all

      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @accounts }
        format.json  { render :json => @accounts }
      end
    end

    def new
      @type = params[:type].pluralize
      @add_delete_action = true
      @account = Plutus::Account.new
    end
  end
end
