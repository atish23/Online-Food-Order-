class Inventory < ActiveRecord::
  has_one :variant

  validate :must_have_stock

  def add_count_on_hand(num)
    if variant.low_stock?
      lock!
      self.count_on_hand = count_on_hand + num.to_i
      save!
    else
      sql = "UPDATE inventories SET count_on_hand = (#{num} + count_on_hand) WHERE id = #{self.id}"
      ActiveRecord::Base.connection.execute(sql)
    end
  end

private
  def must_have_stock
      if (count_on_hand - count_pending_to_customer) < 0
        errors.add :count_on_hand, 'There is not enough stock to sell this item'
      end
  end
end
