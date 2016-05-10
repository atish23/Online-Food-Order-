class CreateInventories < ActiveRecord::Migration
  def change
    create_table :inventories do |t|
      t.integer :count_on_hand,               :default => 0
      t.integer :count_pending_to_customer,   :default => 0
      t.integer :count_pending_from_supplier, :default => 0

      t.timestamps null: false
    end
  end
end
