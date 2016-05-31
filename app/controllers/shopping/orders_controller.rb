class Shopping::OrdersController < Shopping::BaseController
  before_filter :authenticate_user!

  def index
    @order = find_or_create_order
    if f = next_form(@order)
      redirect_to f
    else
      expire_all_browser_cache
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

    if  @order.create_invoice({ email: @order.email, billing_address: address, ip: @order.ip_address},
                  @order.amount_to_credit)

      expire_all_browser_cache
      session_cart.mark_items_purchased(@order)
      session[:last_order] = @order.number
      redirect_to( confirmation_shopping_order_url(@order) ) and return
    else
      flash[:notice] = "Sorry dear we are unable to process your order"
      render :action => 'index'
    end
  end

  def confirmation
    if session[:last_order].present? && session[:last_order] == params[:id]
      session[:last_order] = nil
      @order = Order.where(number: params[:id]).includes({order_items: :variant}).first
      render :layout => 'application'
    else
      session[:last_order] = nil
      if current_user.orders.present?
        redirect_to myaccount_overview_url( current_user.orders.last )
      elsif current_user
        redirect_to myaccount_overview_url
      end
    end
  end

end
