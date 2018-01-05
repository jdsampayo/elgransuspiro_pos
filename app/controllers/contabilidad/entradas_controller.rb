module Contabilidad
  class EntradasController < ApplicationController
    def index
      order = params[:order] == 'ascendente' ? 'ASC' : 'DESC'

      @entries = Plutus::Entry.where("description like ?", "%#{params[:description]}%").page(params[:page]).per(params[:limit]).order("date #{order}")

      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @entries }
        format.json  { render :json => @entries }
      end
    end
  end
end
