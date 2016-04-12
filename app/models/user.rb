class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable



  validates :firstname, :presence => true
  validates :lastname, :presence => true

  has_many :orders, dependent: :destroy

  has_many    :addresses,       dependent: :destroy,       as: :addressable

  has_one     :default_billing_address,   -> { where(billing_default: true, active: true) },
                                          as:         :addressable,
                                          class_name: 'Address'

  has_many    :billing_addresses,         -> { where(active: true) },
                                          as:         :addressable,
                                          class_name: 'Address'

  has_one     :default_shipping_address,  -> { where(default: true, active: true) },
                                          as:         :addressable,
                                          class_name: 'Address'

  has_many     :shipping_addresses,       -> { where(active: true) },
                                          as:         :addressable,
                                          class_name: 'Address'
end
