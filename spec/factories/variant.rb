FactoryGirl.define do
	factory :variant do
	sequence(:name)			{ |i| "Varaint Name #{i}"}
    food         		{ |c| c.association(:food) }
    price               '10'
    sku                  '0001'
    cost                 '22'
    inventory            {|c| c.association(:inventory)}	
	end
end
