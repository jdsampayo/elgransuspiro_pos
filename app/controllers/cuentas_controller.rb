class CuentasController < ApplicationController
  load_and_authorize_resource class: false

  def index
    @cuentas = Plutus::Account.all
  end

  def new
    @cuenta = Cuenta.new
  end

  def create
    @cuenta = Cuenta.new(cuenta_params)
    @cuenta = @cuenta.create

    if @cuenta.errors.blank?
      redirect_to cuentas_url, notice: 'Creada exitosamente.'
    else
      render :new
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def cuenta_params
      params.require(:cuenta).permit(:nombre, :tipo, :contra)
    end
end
