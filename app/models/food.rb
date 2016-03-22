class Food < ActiveRecord::Base
	belongs_to :category
	has_many :order_items
	has_many :orders, through: :order_items

	has_attached_file :food_image, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => ""
  validates_attachment_content_type :food_image, :content_type => /\Aimage\/.*\Z/
end
