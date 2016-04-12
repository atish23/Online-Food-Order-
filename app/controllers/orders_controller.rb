class OrdersController < ApplicationController
	before_filter :authenticate_user!
	def checkout
		  @order = current_user.addresses.new
	end

	def create
		@order = Address.new(address_params)
		
	end

private
	def address_params
		params.require(:address).permit!
	end
end
