class CartItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :cart
  belongs_to :item_type
end
