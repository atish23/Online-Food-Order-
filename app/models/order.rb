class Order < ActiveRecord::Base
	has_many :order_items, :dependent => :destroy
	has_many :foods,through: :order_items
	belongs_to :user

  	belongs_to   :ship_address, class_name: 'Address'
  	belongs_to   :bill_address, class_name: 'Address'


  def self.find_myaccount_details
    includes([:completed_invoices, :invoices])
  end

  def self.include_checkout_objects
    includes([{ship_address: :state},
              {bill_address: :state},
              {order_items:
                {variant:
                  { product: :images }}}])
  end  
end
