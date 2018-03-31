class SesionesController < ApplicationController
  def new
    @sesion = Sesion.new
  end

  def create
    @sesion = Sesion.new(sesion_params.to_h)

    respond_to do |format|
      if @sesion.save
        format.html { redirect_to root_path, notice: '¡Ha iniciado sesión!' }
      else
        format.html { render :new }
      end
    end
  end

  def acceso_denegado
  end

  def destroy
    @sesion = Sesion.find
    @sesion.destroy
    respond_to do |format|
      format.html { redirect_to root_path }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_sesion
    @sesion = Sesion.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def sesion_params
    params.require(:sesion).permit(:email, :password)
  end
end
