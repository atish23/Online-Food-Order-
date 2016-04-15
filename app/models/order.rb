class Order < ActiveRecord::Base
	include AASM

  has_many :order_items, :dependent => :destroy
	has_many :foods,through: :order_items
	
  belongs_to :user
  belongs_to   :ship_address, class_name: 'Address'
  belongs_to   :bill_address, class_name: 'Address'

  attr_accessor :total, :sub_total, :deal_amount, :taxed_total, :deal_time
  
  NUMBER_SEED = 1001001001000
  CHARACTERS_SEED = 21

  aasm column: :state do
    state :in_progress, initial: true
    state :complete
    state :paid 
    state :canceled  
  end

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
