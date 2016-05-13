class CartItem < ActiveRecord::Base
  belongs_to :item_type
  belongs_to :user
  belongs_to :cart
  belongs_to :variant

  validates :item_type_id,  :presence => true
  validates :variant_id,    :presence => true

  QUANTITIES = [1,2,3,4]

  before_save :inactivate_zero_quantity


  def price
    self.variant.price
  end

  def name
    variant.name
  end

  def total
    self.price * self.quantity
  end


  def inactivate!
    self.update_attributes(:active => false)
  end


  def shopping_cart_item?
    item_type_id == ItemType::SHOPPING_CART_ID && active?
  end


  def self.before(at)
    where( "cart_items.created_at <= ?", at )
  end

  private

    def inactivate_zero_quantity
      active = false if quantity == 0
    end
end
