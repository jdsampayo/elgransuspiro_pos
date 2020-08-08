# == Schema Information
#
# Table name: asistencias
#
#  id           :uuid             not null, primary key
#  mesero_id    :uuid
#  corte_id     :uuid
#  horas        :bigint
#  horas_extra  :bigint
#  retardo      :boolean          default(FALSE), not null
#  falta        :boolean          default(FALSE), not null
#  created_at   :datetime
#  updated_at   :datetime
#  hora_entrada :datetime
#  hora_salida  :datetime
#

require 'test_helper'

class AsistenciaTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
