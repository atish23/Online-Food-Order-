class Admin::History::OrdersController < Admin::BaseController
		def index
			@orders = Order.all
		end

		# GET /admin/history/orders/1
		def show
			#raise "hello"
			@order = Order.includes([:ship_address,{:order_items => [
			    {:variant => [:food]}]
			}]).find(params[:id])
		end
end
