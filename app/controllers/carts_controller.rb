class CartsController < ApplicationController
  def index
  	
  end

  def destroy
  	food_id = params[:id]
    @cart.cart_data.delete(food_id)
    render json: items_in_cart
  end

 private
 	def items_in_cart

		items = 0
		if !session[:cart].nil? && session[:cart].length > 0
			session[:cart].each do |_key, value|
				items += value
			end
		end
		items
	end
end
