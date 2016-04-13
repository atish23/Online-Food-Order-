class Myaccount::OrdersController < ApplicationController
  # GET /myaccount/orders
  # GET /myaccount/orders.xml
  def index
    @orders = current_user.finished_orders.find_myaccount_details
  end

  # GET /myaccount/orders/1
  # GET /myaccount/orders/1.xml
  def show
    @order = current_user.finished_orders.includes([:invoices]).find_by_number(params[:id])
  	#raise @order.inspect
  end
end
