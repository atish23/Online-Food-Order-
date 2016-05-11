FactoryGirl.define do
  factory :address do
    first_name 'John'
    last_name  'Doe'
    address1  '112 south park street'
    city       'Fredville'
    state     { State.first }
    zip_code  '54322'
    address_type { AddressType.first}
    addressable  { |c| c.association(:user) }
  end
end