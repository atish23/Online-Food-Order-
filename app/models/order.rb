class Order < ActiveRecord::Base
  #include AASM

  has_many :order_items, :inverse_of => :order, :dependent => :destroy

  has_many   :invoices
  has_many   :completed_invoices,   -> { where(state: ['authorized', 'paid']) },  class_name: 'Invoice'
  has_many   :authorized_invoices,  -> { where(state: 'authorized') },      class_name: 'Invoice'
  has_many   :paid_invoices      ,  -> { where(state: 'paid') },            class_name: 'Invoice'
  has_many   :canceled_invoices   , ->  { where(state: 'canceled') }  ,     class_name: 'Invoice'
 
  
  belongs_to   :user
  belongs_to   :ship_address, class_name: 'Address'
  belongs_to   :bill_address, class_name: 'Address'
  accepts_nested_attributes_for :bill_address, :allow_destroy => true
  accepts_nested_attributes_for :ship_address, :allow_destroy => true
  accepts_nested_attributes_for :order_items
  
  before_validation :set_email, :set_number
  after_create      :save_order_number
  #before_save       :update_tax_rates

  attr_accessor :total, :sub_total #, :taxed_total
  
  validates :user_id,     presence: true
  validates :email,       presence: true,
                          format:   { with: CustomValidators::Emails.email_validator } 
  CHARACTERS_SEED = 20
  NUMBER_SEED     = 2002002002000

  # aasm column: :state do
  #   state :in_progress, initial: true
  #   state :complete
  #   state :paid 
  #   state :canceled  


  #   event :complete do
  #     transitions to: :complete, from: :in_progress
  #   end

  #   event :pay, after: :mark_items_paid do
  #     transitions to: :paid, from: [:in_progress, :complete]
  #   end  

  # end

  def mark_items_paid
    order_items.map(&:pay!)
  end



  def first_invoice_amount
    return '' if completed_invoices.empty? && canceled_invoices.empty?
    completed_invoices.last ? completed_invoices.last.amount : canceled_invoices.last.amount
  end

  def status
    return 'not processed' if invoices.empty?
    invoices.last.state
  end

  def self.between(start_time, end_time)
    where("orders.completed_at >= ? AND orders.completed_at <= ?", start_time, end_time)
  end

  def self.order_by_completion
    order('orders.completed_at asc')
  end

  def self.finished
    where({:orders => { :state => ['complete', 'paid']}})
  end

  def self.find_myaccount_details
    includes([:completed_invoices, :invoices])
  end

  def add_cart_item( item, state_id = nil)
    self.save! if self.new_record?
    item.quantity.times do
      oi =  OrderItem.create(
          :order        => self,
          :variant_id   => item.variant.id,
          :price        => item.variant.price)
      self.order_items.push(oi)
    end
  end

  def create_invoice(args,credited_amount)
    invoice_statement = Invoice.new(order_id: self.id, amount: credited_amount, invoice_type: 'PURCHASE')
    invoice_statement.save
    invoices.push(invoice_statement)
    if invoice_statement
      self.order_complete!
      Notifier.order_confirmation(self.id,invoice_statement.id).deliver_now
    end
  end

  def order_complete!
    self.state = 'complete'
    self.completed_at = Time.zone.now
    update_inventory
  end

  def find_total(force = false)
    self.find_sub_total
    self.total  = self.sub_total
  end

  def find_sub_total
    self.total = 0.0
    order_items.each do |item|
      self.total = self.total + item.price if !item.price.nil?
    end
    self.sub_total = self.total
  end

  def amount_to_credit
    [find_total].min.to_f
  end
  def add_items(variant, quantity, state_id = nil)
    self.save! if self.new_record?
    quantity.times do
      self.order_items.push(OrderItem.create(:order => self,:variant_id => variant.id, :price => variant.price))
    end
  end

  def remove_items(variant, final_quantity)
    current_qty = 0
    items_to_remove = []
    self.order_items.each_with_index do |order_item, i|
      if order_item.variant_id == variant.id
        current_qty = current_qty + 1
        items_to_remove << order_item.id  if (current_qty - final_quantity) > 0
      end
    end
    OrderItem.where(id: items_to_remove).map(&:destroy) unless items_to_remove.empty?
    self.order_items.reload
  end
  
  def self.id_from_number(num)
    num.to_i(CHARACTERS_SEED) - NUMBER_SEED
  end

  def self.find_by_number(num)
    find(id_from_number(num))
  end

  def update_inventory
    #raise "hello"
    self.order_items.each { |item| item.variant.substract_count_on_hand(1) }
  end

  def variant_ids
    order_items.collect{|oi| oi.variant_id }
  end


  def self.include_checkout_objects
    includes([{ship_address: :state},
              {bill_address: :state}])
  end

private
  def item_prices
    order_items.collect{|item| item.adjusted_price }
  end

  def set_email
    self.email = user.email if user_id
  end

  def set_number
    return set_order_number if self.id
    self.number = (Time.now.to_i).to_s(CHARACTERS_SEED)## fake number for friendly_id validator
  end

  def set_order_number
    self.number = (NUMBER_SEED + id).to_s(CHARACTERS_SEED)
  end


  def save_order_number
    set_order_number
    save
  end

end