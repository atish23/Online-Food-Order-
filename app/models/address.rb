class Address < ActiveRecord::Base
  belongs_to  :state
  belongs_to  :country
  belongs_to  :address_type
  belongs_to  :addressable, :polymorphic => true

  attr_accessor :replace_address_id

  before_save :replace_address, if: :replace_address_id

private

	def replace_address
		Address.where(id: replace_address_id).update_all(active: false)
	end
	
end


