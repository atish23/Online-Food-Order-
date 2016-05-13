class Variant < ActiveRecord::Base
  belongs_to :food
  belongs_to :inventory

  before_validation :create_inventory

  validates :inventory_id, presence: true
  validates :price, presence: true
  validates :food_id, presence: true
  validates :sku, presence: true, length: { maximum: 255 }

  delegate :count_on_hand,
              :count_pending_to_customer,
              :count_pending_from_supplier,
              :add_count_on_hand,
              :count_on_hand=,
              :count_pending_from_supplier=,
              :count_pending_from_supplier=, to: :inventory, allow_nil: false
  ADMIN_OUT_OF_STOCK_QTY = 0
  OUT_OF_STOCK_QTY = 2
  LOW_STOCK_QTY = 6

  def quantity_purchaseable(admin_purchase = false)
    admin_purchase ? (quantity_available - ADMIN_OUT_OF_STOCK_QTY) : (quantity_available - OUT_OF_STOCK_QTY)
  end

  def quantity_purchaseable_if_user_wants(this_number_of_items, admin_purchase = false)
    (quantity_purchaseable(admin_purchase) < this_number_of_items) ? quantity_purchaseable(admin_purchase) : this_number_of_items
  end
  def quantity_available
    (count_on_hand - count_pending_to_customer)
  end

  def active?
    deleted_at.nil? || deleted_at > Time.zone.now
  end
  def inactivate=(val)
    return unless val.present?
    if val == '1' || val.to_s == 'true'
      self.deleted_at ||= Time.zone.now
    else
      self.deleted_at = nil
    end
  end

  def inactivate?
    deleted_at ? true : false
  end

  def sold_out?
    (quantity_available) <= OUT_OF_STOCK_QTY
  end

  def low_stock?
    (quantity_available) <= LOW_STOCK_QTY
  end

   def display_stock_status(start = '(', finish = ')')
    return "#{start}Sold Out#{finish}"  if sold_out?
    return "#{start}Low Stock#{finish}" if low_stock?
    ''
  end

  def stock_status
    return "sold_out"  if sold_out?
    return "low_stock"  if low_stock?
    "available"
  end
  def product_name
    name? ? name : [food.name, sub_name].reject{ |a| a.strip.length == 0 }.join(' - ')
  end

  def sub_name
    primary_property ? "#{primary_property.description}" : ''
  end
  def name_with_sku
    [product_name,sku].compact.join(': ')
  end

  def is_available?
    count_available > 0
  end

  def count_availbale(reload_variant = true)
    self.reload if reload_variant
    count_on_hand - count_pending_to_customer
  end

  def substract_count_on_hand(num)
    add_count_on_hand(num.to_i * -1)
  end

  def add_pending_to_customer(num = 1)
    if low_stock?
      inventory.lock!
      self.inventory.count_pending_to_customer = inventory.count_pending_to_customer.to_i + num.to_i
      inventory.save!
    else
      sql = "UPDATE inventories SET count_pending_to_customer = (#{num} + count_pending_to_customer) WHERE id = #{self.inventory.id}"
      ActiveRecord::Base.connection.execute(sql)
    end
  end

  def subtract_pending_to_customer(num)
    add_pending_to_customer((num.to_i * -1))
  end

  def qty_to_add=(num)
    inventory.lock!
    self.inventory.count_on_hand = inventory.count_on_hand.to_i + num.to_i
    inventory.save!
  end

  def qty_to_add
    0
  end
private
  def create_inventory
    self.inventory = Inventory.create({:count_on_hand => 0, :count_pending_to_customer => 0, :count_pending_from_supplier => 0}) unless inventory_id
  end
end
