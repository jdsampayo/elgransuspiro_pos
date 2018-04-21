class AddHorasToAsistencia < ActiveRecord::Migration[5.1]
  def change
    add_column :asistencias, :hora_entrada, :datetime
    add_column :asistencias, :hora_salida, :datetime
  end
end
