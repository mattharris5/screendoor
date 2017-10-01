class Preference < ActiveRecord::Base
  # attr_accessible :key, :value
  validates_presence_of :key, :value
  validates_uniqueness_of :key

  def self.get(key)
    Preference.where(key: key).first_or_initialize.value
  end

  def self.set(key, value)
    p = Preference.where(key: key).first_or_create.update_attribute(:value, value)
    value
  end

end
