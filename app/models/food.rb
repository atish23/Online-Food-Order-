class Food < ActiveRecord::Base
	belongs_to :category
	has_many :order_items
	has_many :orders, through: :order_items

	has_many :variants
	has_many :active_variants, -> { where(deleted_at: nil) },
    class_name: 'Variant'
  	accepts_nested_attributes_for :variants,           reject_if: proc { |attributes| attributes['sku'].blank? }

	has_attached_file :food_image, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => ""
  	validates_attachment_content_type :food_image, :content_type => /\Aimage\/.*\Z/


  def self.active
    where("foods.deleted_at IS NULL OR foods.deleted_at > ?", Time.zone.now)
    #  Add this line if you want the available_at to function
    #where("products.available_at IS NULL OR products.available_at >= ?", Time.zone.now)
  end

  def active(at = Time.zone.now)
    deleted_at.nil? || deleted_at > (at + 1.second)
  end

  def active?(at = Time.zone.now)
    active(at)
  end

  def activate!
    self.deleted_at = nil
    save
  end
 private
     def has_active_variants?
      active_variants.any?{|v| v.is_available? }
    end
end
