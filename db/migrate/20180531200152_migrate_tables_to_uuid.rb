require 'webdack/uuid_migration/helpers'

class MigrateTablesToUuid < ActiveRecord::Migration[5.1]
  def change
    reversible do |dir|
      dir.up do
        add_column :articulos_desechables, :id, :primary_key

        remove_foreign_key "asistencias", name: "asistencias_corte_id_fkey"
        remove_foreign_key "asistencias", name: "asistencias_mesero_id_fkey"
        remove_foreign_key "conteos", name: "conteos_articulo_id_fkey"
        remove_foreign_key "conteos", name: "conteos_corte_id_fkey"
        remove_foreign_key "extra_ordenes", name: "extra_ordenes_extra_id_fkey"
        remove_foreign_key "extra_ordenes", name: "extra_ordenes_orden_id_fkey"

        # Good idea to do the following, needs superuser rights in the database
        # Alternatively the extension needs to be manually enabled in the RDBMS
        enable_extension 'pgcrypto'

        tables = [ :articulos, :meseros, :comandas, :ordenes, :extras, :extra_ordenes, :cortes, :gastos, :categorias, :conteos, :desechables, :articulos_desechables, :plutus_accounts, :plutus_entries, :plutus_amounts, :usuarios, :asistencias, :articulos_desechables, :cortes ]

        tables.each do |table|
          primary_key_to_uuid table
        end

        columns_to_uuid :articulos, :categoria_id
        columns_to_uuid :articulos_desechables, :articulo_id, :desechable_id
        columns_to_uuid :asistencias, :mesero_id, :corte_id
        columns_to_uuid :comandas, :mesero_id, :corte_id
        columns_to_uuid :conteos, :articulo_id, :corte_id
        columns_to_uuid :extra_ordenes, :extra_id, :orden_id
        columns_to_uuid :ordenes, :articulo_id, :comanda_id
        columns_to_uuid :plutus_amounts, :account_id, :entry_id
        columns_to_uuid :plutus_entries, :commercial_document_id

        add_foreign_key "asistencias", "cortes", name: "asistencias_corte_id_fkey"
        add_foreign_key "asistencias", "meseros", name: "asistencias_mesero_id_fkey"
        add_foreign_key "conteos", "articulos", name: "conteos_articulo_id_fkey"
        add_foreign_key "conteos", "cortes", name: "conteos_corte_id_fkey"
        add_foreign_key "extra_ordenes", "extras", name: "extra_ordenes_extra_id_fkey"
        add_foreign_key "extra_ordenes", "ordenes", name: "extra_ordenes_orden_id_fkey"
      end

      dir.down do
        true
      end
    end
  end

=begin
  def up
    tables = [ :articulos, :meseros, :comandas, :ordenes, :extras, :extra_ordenes, :cortes, :gastos, :categorias, :conteos, :desechables, :articulos_desechables, :plutus_accounts, :plutus_entries, :plutus_amounts, :usuarios, :asistencias ]

    tables.each do |table|
      add_column table, :uuid, :uuid, default: "uuid_generate_v4()", null: false
    end
  end

  def down
    tables = [ :articulos, :meseros, :comandas, :ordenes, :extras, :extra_ordenes, :cortes, :gastos, :categorias, :conteos, :desechables, :articulos_desechables, :plutus_accounts, :plutus_entries, :plutus_amounts, :usuarios, :asistencias ]

    tables.each do |table|
      remove_column table, :uuid, :uuid, default: "uuid_generate_v4()", null: false
    end
  end
=end
end
