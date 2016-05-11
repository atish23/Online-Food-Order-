class Admin::Inventory::OverviewsController < Admin::BaseController
	def index
		@foods = Food.active.order("#{params[:sidx]}")
	end
end
