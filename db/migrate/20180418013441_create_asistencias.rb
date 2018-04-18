class CreateAsistencias < ActiveRecord::Migration[5.1]
  def change
    create_table :asistencias do |t|
      t.references :mesero, foreign_key: true
      t.references :corte, foreign_key: true
      t.integer :horas
      t.integer :horas_extra
      t.boolean :retardo
      t.boolean :falta

      t.timestamps
    end
  end
end
