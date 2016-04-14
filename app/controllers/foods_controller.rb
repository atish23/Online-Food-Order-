class FoodsController < ApplicationController
	def index
		@foods = Food.all
	end

	def show
		@food = Food.find(params[:id])
		form_info
	end
private 
	def form_info
		@cart_item = CartItem.new
	end
end
