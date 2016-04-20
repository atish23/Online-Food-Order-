class RemoveColumns < ActiveRecord::Migration
	def self.up
	  remove_column :orders, :status
	  remove_column :orders, :total
	  remove_column :orders, :vat
	  remove_column :orders, :delivery_cost
	  remove_column :orders, :transaction_id
	  remove_column :orders, :invoice
	  remove_column :orders, :pickup_time
	end
	def self.down
  		add_column :orders, :status, :string
  		add_column :orders, :total,  :integer
  		add_column :orders, :vat, :integer
  		add_column :orders, :delivery_cost, :integer
  		add_column :orders, :transaction_id, :string
  		add_column :orders, :invoice, :string
  		add_column :orders, :pickup_time, :integer
	end
end
