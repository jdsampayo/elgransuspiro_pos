# == Schema Information
#
# Table name: asistencias
#
#  id           :uuid             not null, primary key
#  mesero_id    :uuid
#  corte_id     :uuid
#  horas        :bigint(8)
#  horas_extra  :bigint(8)
#  retardo      :boolean
#  falta        :boolean
#  created_at   :datetime
#  updated_at   :datetime
#  hora_entrada :datetime
#  hora_salida  :datetime
#

module AsistenciasHelper
end
