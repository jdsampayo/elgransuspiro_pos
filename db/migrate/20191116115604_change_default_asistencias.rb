class ChangeDefaultAsistencias < ActiveRecord::Migration[6.0]
  def change
    change_column_null(
      :asistencias,
      :falta,
      false, 0
    )

    change_column_null(
      :asistencias,
      :retardo,
      false, 0
    )

    change_column_default(
      :asistencias,
      :falta,
      false
    )

    change_column_default(
      :asistencias,
      :retardo,
      false
    )
  end
end
