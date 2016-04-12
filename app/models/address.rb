class Address < ActiveRecord::Base
  belongs_to  :state
  belongs_to  :country
  belongs_to  :address_type
  belongs_to  :addressable, :polymorphic => true
end
