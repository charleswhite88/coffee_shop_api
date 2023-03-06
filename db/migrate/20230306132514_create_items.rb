class CreateItems < ActiveRecord::Migration[7.0]
  def change
    create_table :items do |t|
      t.string :name, null: false
      t.decimal :price, null: false, default: 0
      t.decimal :tax_rate, null: false, default: 0
      t.integer :discount_item_id
      t.integer :discount_percent, default: 0

      t.timestamps
    end

    add_foreign_key :items, :items, column: :discount_item_id, on_delete: :nullify
  end
end

