class CreateIzettleTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :izettle_transactions, id: :uuid do |t|
      t.timestamp :transacted_at
      t.decimal :amount
      t.integer :transaction_type
      t.uuid :payment_id
      t.references :izettle_purchase, null: true, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
