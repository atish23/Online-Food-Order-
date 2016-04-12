class Order < ActiveRecord::Base
	has_many :order_items
	has_many :foods,through: :order_items
	belongs_to :user

  	belongs_to   :ship_address, class_name: 'Address'
  	belongs_to   :bill_address, class_name: 'Address'
end
