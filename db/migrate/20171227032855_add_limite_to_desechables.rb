class AddLimiteToDesechables < ActiveRecord::Migration[5.1]
  def change
    add_column :desechables, :limite, :integer
  end
end
