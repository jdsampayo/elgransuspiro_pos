# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180531200152) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"
  enable_extension "pgcrypto"

  create_table "articulos", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "nombre"
    t.decimal "precio", default: "0.0"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.uuid "categoria_id"
    t.datetime "deleted_at"
    t.index ["categoria_id"], name: "idx_17601_index_articulos_on_categoria_id"
    t.index ["deleted_at"], name: "idx_17601_index_articulos_on_deleted_at"
  end

  create_table "articulos_desechables", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "articulo_id"
    t.uuid "desechable_id"
    t.index ["articulo_id", "desechable_id"], name: "idx_17713_index_articulos_desechables_on_articulo_id_and_desech"
    t.index ["desechable_id", "articulo_id"], name: "idx_17713_index_articulos_desechables_on_desechable_id_and_arti"
  end

  create_table "asistencias", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "mesero_id"
    t.uuid "corte_id"
    t.bigint "horas"
    t.bigint "horas_extra"
    t.boolean "retardo"
    t.boolean "falta"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "hora_entrada"
    t.datetime "hora_salida"
    t.index ["corte_id"], name: "idx_17754_index_asistencias_on_corte_id"
    t.index ["mesero_id"], name: "idx_17754_index_asistencias_on_mesero_id"
  end

  create_table "categorias", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "nombre"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "idx_17690_index_categorias_on_deleted_at"
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
    t.boolean "pago_con_tarjeta", default: false
    t.uuid "corte_id"
    t.decimal "propina", default: "0.0"
    t.integer "porcentaje_de_descuento", default: 0
    t.index ["closed_at"], name: "idx_17656_index_comandas_on_closed_at"
    t.index ["deleted_at"], name: "idx_17656_index_comandas_on_deleted_at"
    t.index ["mesero_id"], name: "idx_17656_index_comandas_on_mesero_id"
  end

  create_table "conteos", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "articulo_id"
    t.uuid "corte_id"
    t.bigint "total", default: 0
    t.datetime "deleted_at"
    t.index ["articulo_id"], name: "idx_17699_index_conteos_on_articulo_id"
    t.index ["corte_id"], name: "idx_17699_index_conteos_on_corte_id"
    t.index ["deleted_at"], name: "idx_17699_index_conteos_on_deleted_at"
  end

  create_table "cortes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.date "dia"
    t.decimal "inicial", default: "0.0"
    t.decimal "ventas", default: "0.0"
    t.decimal "gastos", default: "0.0"
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
    t.index ["deleted_at"], name: "idx_17673_index_cortes_on_deleted_at"
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
    t.index ["deleted_at"], name: "idx_17706_index_desechables_on_deleted_at"
  end

  create_table "extra_ordenes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "extra_id"
    t.uuid "orden_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "idx_17640_index_extra_ordenes_on_deleted_at"
    t.index ["extra_id"], name: "idx_17640_index_extra_ordenes_on_extra_id"
    t.index ["orden_id"], name: "idx_17640_index_extra_ordenes_on_orden_id"
  end

  create_table "extras", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "nombre"
    t.decimal "precio", default: "0.0"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "idx_17630_index_extras_on_deleted_at"
  end

  create_table "gastos", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.decimal "monto", default: "0.0"
    t.text "descripcion"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "idx_17646_index_gastos_on_deleted_at"
  end

  create_table "meseros", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "nombre"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "idx_17611_index_meseros_on_deleted_at"
  end

  create_table "ordenes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "articulo_id"
    t.uuid "comanda_id"
    t.bigint "cantidad"
    t.decimal "precio_unitario", default: "0.0"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "para_llevar"
    t.datetime "deleted_at"
    t.index ["comanda_id"], name: "idx_17620_index_ordenes_on_comanda_id"
    t.index ["deleted_at"], name: "idx_17620_index_ordenes_on_deleted_at"
  end

  create_table "plutus_accounts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "name"
    t.text "type"
    t.boolean "contra"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["name", "type"], name: "idx_17718_index_plutus_accounts_on_name_and_type"
  end

  create_table "plutus_amounts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "type"
    t.uuid "account_id"
    t.uuid "entry_id"
    t.decimal "amount", precision: 20, scale: 10
    t.index ["account_id", "entry_id"], name: "idx_17736_index_plutus_amounts_on_account_id_and_entry_id"
    t.index ["entry_id", "account_id"], name: "idx_17736_index_plutus_amounts_on_entry_id_and_account_id"
    t.index ["type"], name: "idx_17736_index_plutus_amounts_on_type"
  end

  create_table "plutus_entries", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "description"
    t.date "date"
    t.uuid "commercial_document_id"
    t.text "commercial_document_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["commercial_document_id", "commercial_document_type"], name: "idx_17727_index_entries_on_commercial_doc"
    t.index ["date"], name: "idx_17727_index_plutus_entries_on_date"
  end

  create_table "usuarios", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "email"
    t.text "crypted_password"
    t.text "password_salt"
    t.text "persistence_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_foreign_key "asistencias", "cortes", name: "asistencias_corte_id_fkey"
  add_foreign_key "asistencias", "meseros", name: "asistencias_mesero_id_fkey"
  add_foreign_key "conteos", "articulos", name: "conteos_articulo_id_fkey"
  add_foreign_key "conteos", "cortes", name: "conteos_corte_id_fkey"
  add_foreign_key "extra_ordenes", "extras", name: "extra_ordenes_extra_id_fkey"
  add_foreign_key "extra_ordenes", "ordenes", name: "extra_ordenes_orden_id_fkey"
end
