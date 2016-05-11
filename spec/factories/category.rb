FactoryGirl.define do
	factory :category do
		sequence(:title)			{ |i| "Category Name #{i}"}
		description					'Describe Product'
	end
end