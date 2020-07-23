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
    render layout: nil
  end

  def destroy
    current_user_session.destroy if current_user_session
    redirect_to login_url
  end

  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def sesion_params
    params.require(:sesion).permit(:email, :password, :remember_me)
  end
end
