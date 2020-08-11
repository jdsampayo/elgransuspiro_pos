class AddFolioToComandas < ActiveRecord::Migration[6.0]
  def change
    add_column :comandas, :folio, :integer
  end
end
