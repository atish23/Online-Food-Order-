require 'spec_helper'

describe Admin::History::OrdersController do
	render_views

	before(:each) do
		@request.env["devise.mapping"] = Devise.mappings[:user]
		@user = create_admin_user
		login_user(@user)
	end

	it "show action should render show template" do
		@order = FactoryGirl.create(:order)
		#raise @order.inspect
		get :show, :id => "1"
		expect(response).to render_template(:show)
	end
	
	it "index action should render index template" do
		get :index
		expect(response).to render_template(:index)
	end


end