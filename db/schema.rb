# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_08_08_201843) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "active_storage_attachments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.uuid "record_id", null: false
    t.string "record_type", null: false
    t.uuid "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "articulos", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "nombre"
    t.decimal "precio", default: "0.0"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.uuid "categoria_id"
    t.datetime "deleted_at"
    t.index ["categoria_id"], name: "idx_19724_index_articulos_on_categoria_id"
    t.index ["deleted_at"], name: "idx_19724_index_articulos_on_deleted_at"
  end

  create_table "articulos_desechables", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "articulo_id"
    t.uuid "desechable_id"
    t.index ["articulo_id", "desechable_id"], name: "idx_19836_index_articulos_desechables_on_articulo_id_and_desech"
    t.index ["desechable_id", "articulo_id"], name: "idx_19836_index_articulos_desechables_on_desechable_id_and_arti"
  end

  create_table "articulos_extras", id: false, force: :cascade do |t|
    t.uuid "articulo_id", null: false
    t.uuid "extra_id", null: false
    t.index ["articulo_id", "extra_id"], name: "index_articulos_extras_on_articulo_id_and_extra_id"
    t.index ["extra_id", "articulo_id"], name: "index_articulos_extras_on_extra_id_and_articulo_id"
  end

  create_table "asistencias", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "mesero_id"
    t.uuid "corte_id"
    t.bigint "horas"
    t.bigint "horas_extra"
    t.boolean "retardo", default: false, null: false
    t.boolean "falta", default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "hora_entrada"
    t.datetime "hora_salida"
    t.index ["corte_id"], name: "idx_19877_index_asistencias_on_corte_id"
    t.index ["mesero_id"], name: "idx_19877_index_asistencias_on_mesero_id"
  end

  create_table "categorias", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "nombre"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "idx_19813_index_categorias_on_deleted_at"
  end

  create_table "comandas", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.decimal "venta", default: "0.0"
    t.decimal "descuento", default: "0.0"
    t.decimal "total", default: "0.0"
    t.uuid "mesero_id"
    t.datetime "deleted_at"
    t.datetime "closed_at"
    t.bigint "comensales", default: 1
    t.text "mesa", default: "PARA LLEVAR"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "es_pago_con_tarjeta", default: false
    t.uuid "corte_id"
    t.decimal "propina_con_efectivo", default: "0.0"
    t.bigint "porcentaje_de_descuento", default: 0
    t.decimal "propina_con_tarjeta", default: "0.0"
    t.decimal "pago_con_efectivo", default: "0.0"
    t.decimal "pago_con_tarjeta", default: "0.0"
    t.integer "folio"
    t.index ["closed_at"], name: "idx_19779_index_comandas_on_closed_at"
    t.index ["deleted_at"], name: "idx_19779_index_comandas_on_deleted_at"
    t.index ["mesero_id"], name: "idx_19779_index_comandas_on_mesero_id"
  end

  create_table "conteos", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "articulo_id"
    t.uuid "corte_id"
    t.bigint "total", default: 0
    t.datetime "deleted_at"
    t.index ["articulo_id"], name: "idx_19822_index_conteos_on_articulo_id"
    t.index ["corte_id"], name: "idx_19822_index_conteos_on_corte_id"
    t.index ["deleted_at"], name: "idx_19822_index_conteos_on_deleted_at"
  end

  create_table "cortes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.date "dia"
    t.decimal "inicial", default: "0.0"
    t.decimal "ventas", default: "0.0"
    t.decimal "sum_gastos", default: "0.0"
    t.decimal "total", default: "0.0"
    t.decimal "siguiente_dia", default: "0.0"
    t.decimal "sobre", default: "0.0"
    t.datetime "closed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal "pagos_con_tarjeta", default: "0.0"
    t.decimal "pagos_con_efectivo", default: "0.0"
    t.datetime "deleted_at"
    t.decimal "propinas"
    t.uuid "sucursal_id"
    t.index ["deleted_at"], name: "idx_19796_index_cortes_on_deleted_at"
    t.index ["sucursal_id"], name: "index_cortes_on_sucursal_id"
  end

  create_table "desechables", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "nombre"
    t.bigint "en_bodega"
    t.bigint "cantidad"
    t.decimal "costo_unitario"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.bigint "limite"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "idx_19829_index_desechables_on_deleted_at"
  end

  create_table "extra_ordenes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "extra_id"
    t.uuid "orden_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "idx_19763_index_extra_ordenes_on_deleted_at"
    t.index ["extra_id"], name: "idx_19763_index_extra_ordenes_on_extra_id"
    t.index ["orden_id"], name: "idx_19763_index_extra_ordenes_on_orden_id"
  end

  create_table "extras", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "nombre"
    t.decimal "precio", default: "0.0"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "idx_19753_index_extras_on_deleted_at"
  end

  create_table "gastos", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.decimal "monto", default: "0.0"
    t.text "descripcion"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.uuid "corte_id"
    t.index ["corte_id"], name: "index_gastos_on_corte_id"
    t.index ["deleted_at"], name: "idx_19769_index_gastos_on_deleted_at"
  end

# Could not dump table "insumos" because of following StandardError
#   Unknown type 'insumo_paquete' for column 'paquete'

  create_table "meseros", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "nombre"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "idx_19734_index_meseros_on_deleted_at"
  end

  create_table "ordenes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "articulo_id"
    t.uuid "comanda_id"
    t.bigint "cantidad", default: 1
    t.decimal "precio_unitario", default: "0.0"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "para_llevar"
    t.datetime "deleted_at"
    t.index ["comanda_id"], name: "idx_19743_index_ordenes_on_comanda_id"
    t.index ["deleted_at"], name: "idx_19743_index_ordenes_on_deleted_at"
  end

  create_table "plutus_accounts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "name"
    t.text "type"
    t.boolean "contra"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["name", "type"], name: "idx_19841_index_plutus_accounts_on_name_and_type"
  end

  create_table "plutus_amounts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "type"
    t.uuid "account_id"
    t.uuid "entry_id"
    t.decimal "amount", precision: 20, scale: 10
    t.index ["account_id", "entry_id"], name: "idx_19859_index_plutus_amounts_on_account_id_and_entry_id"
    t.index ["entry_id", "account_id"], name: "idx_19859_index_plutus_amounts_on_entry_id_and_account_id"
    t.index ["type"], name: "idx_19859_index_plutus_amounts_on_type"
  end

  create_table "plutus_entries", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "description"
    t.date "date"
    t.uuid "commercial_document_id"
    t.text "commercial_document_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["commercial_document_id", "commercial_document_type"], name: "idx_19850_index_entries_on_commercial_doc"
    t.index ["date"], name: "idx_19850_index_plutus_entries_on_date"
  end

  create_table "sincronizaciones", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "mensaje"
    t.string "path"
    t.string "tipo"
    t.datetime "webhooked_at"
    t.text "error"
    t.boolean "exito", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sucursales", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "nombre"
    t.text "direccion"
    t.string "telefono"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "usuarios", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "email"
    t.text "crypted_password"
    t.text "password_salt"
    t.text "persistence_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "roles"
    t.integer "login_count", default: 0, null: false
    t.integer "failed_login_count", default: 0, null: false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string "current_login_ip"
    t.string "last_login_ip"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "asistencias", "cortes", name: "asistencias_corte_id_fkey"
  add_foreign_key "asistencias", "meseros", name: "asistencias_mesero_id_fkey"
  add_foreign_key "conteos", "articulos", name: "conteos_articulo_id_fkey"
  add_foreign_key "conteos", "cortes", name: "conteos_corte_id_fkey"
  add_foreign_key "cortes", "sucursales"
  add_foreign_key "extra_ordenes", "extras", name: "extra_ordenes_extra_id_fkey"
  add_foreign_key "extra_ordenes", "ordenes", name: "extra_ordenes_orden_id_fkey"
  add_foreign_key "gastos", "cortes"
end
