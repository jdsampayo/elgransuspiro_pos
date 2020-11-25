class CreateIzettlePurchases < ActiveRecord::Migration[6.0]
  def change
    create_table :izettle_purchases, id: :uuid do |t|
      t.decimal :amount
      t.datetime :purchased_at
      t.string :cc_masked_number
      t.string :cc_brand
      t.uuid :payment_id
      t.references :comanda, null: true, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
