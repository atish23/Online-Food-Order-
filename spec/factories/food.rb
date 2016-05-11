FactoryGirl.define do
	factory :food do
		sequence(:name)			{ |i| "Food Name #{i}"}
		description					'Describe Product'
		short_description		'Describe Product'
    category         		{ |c| c.association(:category) }
    available_at        Time.now
    deleted_at          nil
    featured            true
    meta_description    'Describe the variant'
    meta_keywords       'Key One, Key Two'		
	end
end