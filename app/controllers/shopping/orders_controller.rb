class Shopping::OrdersController < Shopping::BaseController
	def index
		@order = find_or_create_order
		if f = next_form(@order)
			redirect_to f
		else
			form_info
		end
	end
private
	def form_info
		@order.credited_total
	end
end
