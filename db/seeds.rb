# puts "START SEEDING"

# puts "COUNTRIES"
# file_to_load  = Rails.root + 'db/seed/countries.yml'
# countries_list   = YAML::load( File.open( file_to_load ) )

# countries_list.each_pair do |key,country|
#   s = Country.find_by(abbreviation: country['abbreviation'])
#   unless s
#     c = Country.create(country) unless s
#     c.update_attribute(:active, true) if Country::ACTIVE_COUNTRY_IDS.include?(c.id)
#   end
# end

# puts "States"
# file_to_load  = Rails.root + 'db/seed/states.yml'
# states_list   = YAML::load( File.open( file_to_load ) )


# states_list.each_pair do |key,state|
#   s = State.find_by(abbreviation: state['attributes']['abbreviation'], country_id: state['attributes']['country_id'])
#   State.create(state['attributes']) unless s
# end

# puts "ROLES"
# roles = Role::ROLES
# roles.each do |role|
#   Role.find_or_create_by(name: role)
# end

# puts "Address Types"
# AddressType::NAMES.each do |address_type|
#   AddressType.find_or_create_by(name: address_type)
# end

