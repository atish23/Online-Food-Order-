require 'rails_helper'

RSpec.describe Admin::Inventory::AdjustmentsController, :type => :controller do
	render_views

	before(:each) do
		@request.env["devise.mapping"] = Devise.mappings[:user]
		@user = create_admin_user
		login_user(@user)
		@food = FactoryGirl.create(:food)
	end	

	it "show action should render show template" do
		get :show , :id => @food.id
		expect(response).to render_template(:show)
	end

	it "index action should render index template" do
		get :index
		expect(response).to render_template(:index)
	end

	it "edit action should render edit template" do
		@variant = FactoryGirl.create(:variant)
		get :edit, :id => @variant.id
	end

	it "update action should render edit template when model is invalid" do
		@variant = FactoryGirl.create(:variant)
		Variant.any_instance.stubs(:valid?).returns(false)
		put :update, :id => @variant.id
		expect(response).to render_template(:edit)
	end

	it "update action should redirect when model is valid" do
		@food = FactoryGirl.create(:food)
		@variant = FactoryGirl.create(:variant,:food => @food)
		Variant.any_instance.stubs(:valid?).returns(true)
		put :update, :id => @variant.id, :variant => {:qty_to_add => '-3'}
		expect(response).to redirect_to(admin_inventory_adjustment_url(@variant))		
	end
end
