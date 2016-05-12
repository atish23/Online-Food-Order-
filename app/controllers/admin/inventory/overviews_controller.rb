class Admin::Inventory::OverviewsController < Admin::BaseController
	def index
		@foods = Food.active.includes({:variants => [:inventory]})
		
	end
end

