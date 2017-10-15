class CreateMeseros < ActiveRecord::Migration[5.1]
  def change
    create_table :meseros do |t|
      t.string :nombre

      t.timestamps
    end
  end
end
