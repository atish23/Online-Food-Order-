class Shopping::AddressesController < Shopping::BaseController

	def index
		@form_address = @shopping_address = Address.new
    form_info
	end

	def show
		
	end

private
	def form_info
    	@shopping_addresses = current_user.addresses
    	#@states     = State.form_selector
	end
end
