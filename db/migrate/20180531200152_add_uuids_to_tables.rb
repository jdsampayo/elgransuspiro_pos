class AddUuidsToTables < ActiveRecord::Migration[5.1]
  def up
    tables = [ :articulos, :meseros, :comandas, :ordenes, :extras, :extra_ordenes, :cortes, :gastos, :categorias, :conteos, :desechables, :articulos_desechables, :plutus_accounts, :plutus_entries, :plutus_amounts, :usuarios, :asistencias ]

    tables.each do |table|
      add_column table, :uuid, :uuid, default: "uuid_generate_v4()", null: false
    end
  end
end
