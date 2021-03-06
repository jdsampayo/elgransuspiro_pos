# == Schema Information
#
# Table name: sucursales
#
#  id         :uuid             not null, primary key
#  nombre     :string
#  direccion  :text
#  telefono   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class SucursalesController < ApplicationController
  load_and_authorize_resource

  def index
    @sucursales = Sucursal.all
  end

  def set
    cookies.permanent[:sucursal] = params[:nombre] if params[:nombre]
  end
end
