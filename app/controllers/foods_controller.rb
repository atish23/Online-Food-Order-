class FoodsController < ApplicationController
	def index
		@foods = Food.active.includes(:variants)
		form_info
	end

	def show
		@food = Food.active.find(params[:id])
		form_info
		@cart_item.variant_id = @food.active_variants.first.try(:id)
	end
private 
  def form_info
    @cart_item = CartItem.new
  end

  def featured_product_types
    [ProductType::FEATURED_TYPE_ID]
  end
end
