class Shopping::AddressesController < Shopping::BaseController

	def index
		@form_address = @shopping_address = Address.new
    	form_info
	end

	def create
			if params[:address].present?
				@shopping_address = current_user.addresses.new(allowed_params)
				@shopping_address.default = true					if current_user.default_shipping_address.nil?
				@shopping_address.billing_default = true	if current_user.default_billing_address.nil?
				@shopping_address.save
				@form_address = @shopping_address
			elsif params[:shopping_address_id].present?
				@shopping_address = current_user.address.find(params[:shopping_address_id])
			end

			if @shopping_address.id
				update_order_address_id(@shopping_address.id)
				redirect_to(shopping_orders_url, :notice => 'Address was succesfully Created..')
			else
				form_info
				render :action => "index"
			end
	end
	
  def select_address
    address = current_user.addresses.find(params[:id])
    update_order_address_id(address.id)
    redirect_to shopping_orders_url
  end

	def show
		
	end

private
	def allowed_params
		params.require(:address).permit(:first_name, :last_name, :address1, :address2, :city, :state_id, :state_name, :zip_code, :default, :billing_default)
	end

	def form_info
    	@shopping_addresses = current_user.addresses
    	#@states     = State.form_selector
	end

	def update_order_address_id(id)
		session_order.update_attributes(
													:ship_address_id => id,
													:bill_address_id => (session_order.bill_address_id ? session_order.bill_address_id : id)
													)
	end
end
