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

ActiveRecord::Schema.define(version: 20171222012315) do

  create_table "articulos", force: :cascade do |t|
    t.string "nombre"
    t.decimal "precio", default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "categoria_id"
    t.index ["categoria_id"], name: "index_articulos_on_categoria_id"
  end

  create_table "categorias", force: :cascade do |t|
    t.string "nombre"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.index ["closed_at"], name: "index_comandas_on_closed_at"
    t.index ["deleted_at"], name: "index_comandas_on_deleted_at"
    t.index ["mesero_id"], name: "index_comandas_on_mesero_id"
  end

  create_table "conteos", force: :cascade do |t|
    t.integer "articulo_id"
    t.integer "corte_id"
    t.integer "total", default: 0
    t.index ["articulo_id"], name: "index_conteos_on_articulo_id"
    t.index ["corte_id"], name: "index_conteos_on_corte_id"
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
  end

  create_table "extra_ordenes", force: :cascade do |t|
    t.integer "extra_id"
    t.integer "orden_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["extra_id"], name: "index_extra_ordenes_on_extra_id"
    t.index ["orden_id"], name: "index_extra_ordenes_on_orden_id"
  end

  create_table "extras", force: :cascade do |t|
    t.string "nombre"
    t.decimal "precio", default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "gastos", force: :cascade do |t|
    t.decimal "monto", default: "0.0"
    t.string "descripcion"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "meseros", force: :cascade do |t|
    t.string "nombre"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ordenes", force: :cascade do |t|
    t.integer "articulo_id"
    t.integer "comanda_id"
    t.integer "cantidad"
    t.decimal "precio_unitario", default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["comanda_id"], name: "index_ordenes_on_comanda_id"
  end

end
