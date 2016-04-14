class Shopping::OrdersController < Shopping::BaseController
	before_filter :authenticate_user!
	def index
		@order = find_or_create_order
		if f = next_form(@order)
			raise f.inspect
			redirect_to f
		else
			form_info
		end
	end

	def checkout
		order = find_or_create_order
		@order = session_cart.add_items_to_checkout(order)
		redirect_to next_form_url(order)
	end

	def update
		@order = find_or_create_order
		@order.ip_address = request.remote_ip
		address = @order.bill_address.cc_params
		
	end
private
	def form_info
		#@order.credited_total
	end
end
