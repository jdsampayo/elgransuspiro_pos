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

ActiveRecord::Schema.define(version: 20180515210327) do

  create_table "articulos", force: :cascade do |t|
    t.string "nombre"
    t.decimal "precio", default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "categoria_id"
    t.datetime "deleted_at"
    t.index ["categoria_id"], name: "index_articulos_on_categoria_id"
    t.index ["deleted_at"], name: "index_articulos_on_deleted_at"
  end

  create_table "articulos_desechables", id: false, force: :cascade do |t|
    t.integer "articulo_id", null: false
    t.integer "desechable_id", null: false
    t.index ["articulo_id", "desechable_id"], name: "index_articulos_desechables_on_articulo_id_and_desechable_id"
    t.index ["desechable_id", "articulo_id"], name: "index_articulos_desechables_on_desechable_id_and_articulo_id"
  end

  create_table "asistencias", force: :cascade do |t|
    t.integer "mesero_id"
    t.integer "corte_id"
    t.integer "horas"
    t.integer "horas_extra"
    t.boolean "retardo"
    t.boolean "falta"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "hora_entrada"
    t.datetime "hora_salida"
    t.index ["corte_id"], name: "index_asistencias_on_corte_id"
    t.index ["mesero_id"], name: "index_asistencias_on_mesero_id"
  end

  create_table "categorias", force: :cascade do |t|
    t.string "nombre"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_categorias_on_deleted_at"
  end

  create_table "comandas", force: :cascade do |t|
    t.decimal "venta", default: "0.0"
    t.decimal "descuento", default: "0.0"
    t.decimal "total", default: "0.0"
    t.integer "mesero_id"
    t.datetime "deleted_at"
    t.datetime "closed_at"
    t.integer "comensales", default: 1
    t.string "mesa", default: "PARA LLEVAR"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "pago_con_tarjeta", default: false
    t.integer "corte_id"
    t.decimal "propina", default: "0.0"
    t.integer "porcentaje_de_descuento", default: 0
    t.index ["closed_at"], name: "index_comandas_on_closed_at"
    t.index ["deleted_at"], name: "index_comandas_on_deleted_at"
    t.index ["mesero_id"], name: "index_comandas_on_mesero_id"
  end

  create_table "conteos", force: :cascade do |t|
    t.integer "articulo_id"
    t.integer "corte_id"
    t.integer "total", default: 0
    t.datetime "deleted_at"
    t.index ["articulo_id"], name: "index_conteos_on_articulo_id"
    t.index ["corte_id"], name: "index_conteos_on_corte_id"
    t.index ["deleted_at"], name: "index_conteos_on_deleted_at"
  end

  create_table "cortes", force: :cascade do |t|
    t.date "dia"
    t.decimal "inicial", default: "0.0"
    t.decimal "ventas", default: "0.0"
    t.decimal "gastos", default: "0.0"
    t.decimal "total", default: "0.0"
    t.decimal "siguiente_dia", default: "0.0"
    t.decimal "sobre", default: "0.0"
    t.datetime "closed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "pagos_con_tarjeta", default: "0.0"
    t.decimal "pagos_con_efectivo", default: "0.0"
    t.datetime "deleted_at"
    t.decimal "propinas"
    t.index ["deleted_at"], name: "index_cortes_on_deleted_at"
  end

  create_table "desechables", force: :cascade do |t|
    t.string "nombre"
    t.integer "en_bodega"
    t.integer "cantidad"
    t.decimal "costo_unitario"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "limite"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_desechables_on_deleted_at"
  end

  create_table "extra_ordenes", force: :cascade do |t|
    t.integer "extra_id"
    t.integer "orden_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_extra_ordenes_on_deleted_at"
    t.index ["extra_id"], name: "index_extra_ordenes_on_extra_id"
    t.index ["orden_id"], name: "index_extra_ordenes_on_orden_id"
  end

  create_table "extras", force: :cascade do |t|
    t.string "nombre"
    t.decimal "precio", default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_extras_on_deleted_at"
  end

  create_table "gastos", force: :cascade do |t|
    t.decimal "monto", default: "0.0"
    t.string "descripcion"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_gastos_on_deleted_at"
  end

  create_table "meseros", force: :cascade do |t|
    t.string "nombre"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_meseros_on_deleted_at"
  end

  create_table "ordenes", force: :cascade do |t|
    t.integer "articulo_id"
    t.integer "comanda_id"
    t.integer "cantidad"
    t.decimal "precio_unitario", default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "para_llevar"
    t.datetime "deleted_at"
    t.index ["comanda_id"], name: "index_ordenes_on_comanda_id"
    t.index ["deleted_at"], name: "index_ordenes_on_deleted_at"
  end

  create_table "plutus_accounts", force: :cascade do |t|
    t.string "name"
    t.string "type"
    t.boolean "contra"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["name", "type"], name: "index_plutus_accounts_on_name_and_type"
  end

  create_table "plutus_amounts", force: :cascade do |t|
    t.string "type"
    t.integer "account_id"
    t.integer "entry_id"
    t.decimal "amount", precision: 20, scale: 10
    t.index ["account_id", "entry_id"], name: "index_plutus_amounts_on_account_id_and_entry_id"
    t.index ["entry_id", "account_id"], name: "index_plutus_amounts_on_entry_id_and_account_id"
    t.index ["type"], name: "index_plutus_amounts_on_type"
  end

  create_table "plutus_entries", force: :cascade do |t|
    t.string "description"
    t.date "date"
    t.integer "commercial_document_id"
    t.string "commercial_document_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["commercial_document_id", "commercial_document_type"], name: "index_entries_on_commercial_doc"
    t.index ["date"], name: "index_plutus_entries_on_date"
  end

  create_table "usuarios", force: :cascade do |t|
    t.string "email"
    t.string "crypted_password"
    t.string "password_salt"
    t.string "persistence_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
