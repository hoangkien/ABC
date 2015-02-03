class Tour < ActiveRecord::Base

  has_and_belongs_to_many :travellers
  has_and_belongs_to_many :tourguides
end
