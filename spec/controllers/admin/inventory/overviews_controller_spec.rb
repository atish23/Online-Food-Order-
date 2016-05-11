require 'rails_helper'

RSpec.describe Admin::Inventory::OverviewsController, :type => :controller do
	render_views

	before(:each) do
		@request.env["devise.mapping"] = Devise.mappings[:user]
		@user = create_admin_user
		login_user(@user)
		@food = FactoryGirl.create(:food)
	end	

	it "index action should render index template" do
		get :index
		expect(response).to render_template(:index)
	end

	
end
