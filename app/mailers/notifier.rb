class Notifier < ApplicationMailer
	
	def order_confirmation(order_id,invoice_id)
		@invoice = Invoice.find(invoice_id)
		@order = Order.includes(:user).find(order_id)
		@user = @order.user
		@url = root_url
		@site_name = 'site_name'
		mail(:to => @order.email,
			:subject => "Order Confirmation")
	end
end
