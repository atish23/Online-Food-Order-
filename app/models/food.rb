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
end
