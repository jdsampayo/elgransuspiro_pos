class CreateSincronizaciones < ActiveRecord::Migration[5.1]
  def change
    create_table :sincronizaciones, id: :uuid do |t|
      t.text :mensaje
      t.string :path
      t.string :tipo
      t.datetime :webhooked_at
      t.text :error
      t.boolean :exito, default: false

      t.timestamps
    end
  end
end
