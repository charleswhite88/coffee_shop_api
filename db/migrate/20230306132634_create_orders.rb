class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.string :customer_name, null: false, limit: 255
      t.decimal :total_cost, null: false, default: 0.0
      t.string :paid, null: false, limit: 255
      t.integer :status, null: false, default: 0

      t.timestamps
    end
  end
end
