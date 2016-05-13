class Admin::Inventory::AdjustmentsController < Admin::BaseController
	def index
		@foods = Food.all
	end
	def show
		@food = Food.includes(:variants).find(params[:id])
	end

	def edit
		@variant = Variant.includes(:food).find(params[:id])
	end

	def update
		@variant = Variant.find(params[:id])
		if params[:variant][:qty_to_add].present?
			if @variant.update_attributes(allowed_params)
				flash[:notice] = "Inventory updated succesfully"
				redirect_to admin_inventory_adjustment_url(@variant)
			else
				flash[:warning] = "Can not be updated"
				render :action => 'edit', :id => params[:id]
			end
		end
	end

private
	def allowed_params
		params.require(:variant).permit(:qty_to_add)
	end
end
