class CreateCortes < ActiveRecord::Migration[5.1]
  def change
    create_table :cortes do |t|
      t.date :dia
      t.decimal :inicial, default: 0
      t.decimal :ventas, default: 0
      t.decimal :gastos, default: 0
      t.decimal :total, default: 0
      t.decimal :siguiente_dia, default: 0
      t.decimal :sobre, default: 0
      t.datetime :closed_at

      t.timestamps
    end
  end
end
