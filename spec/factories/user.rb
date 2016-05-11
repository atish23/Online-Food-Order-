FactoryGirl.define do
	factory :user do
		firstname 'Atish'
		lastname 'Maske'
		sequence(:email)	{ |n| "person#{n}@example.com"}
   	password              'pasword12'
   	password_confirmation "pasword12"		
	end

	factory :admin_user, parent: :user do
		after(:create) do |u|
			u.roles = [Role.find_by_name(Role::ADMIN)]
		end 
	end

	factory :super_admin_user, parent: :user do
		#roles     {
		#  [Role.find_by_name(Role::SUPER_ADMIN)]
		#}
		after(:create) do |u|
		  u.roles = [Role.find_by_name(Role::SUPER_ADMIN)]
		end
	end
end