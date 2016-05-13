class Country < ActiveRecord::Base
  has_many :states

  #belongs_to :shipping_zone

  validates :name,  :presence => true,       :length => { :maximum => 200 }
  validates :abbreviation,  :presence => true,       :length => { :maximum => 10 }

  scope :active_countries,   -> {where(:active => true)}
  scope :inactive_countries, -> {where(:active => false)}

  USA_ID    = 214
  CANADA_ID = 35

  after_save :expire_cache

  ACTIVE_COUNTRY_IDS = [CANADA_ID, USA_ID]


  def abbreviation_name(append_name = "")
    ([abbreviation, name].join(" - ") + " #{append_name}").strip
  end


  def abbrev_and_name
    abbreviation_name
  end

  def self.active
    where(:active => true)
  end

  def self.form_selector
    Rails.cache.fetch("Country-form_selector") do
      data = Country.where(:active => true).order('abbreviation ASC').map { |c| [c.abbrev_and_name, c.id] }
      data.blank? ? [[]] : data
    end
  end
  private
  def expire_cache
    Rails.cache.delete("Country-form_selector")
  end
end
