class Traveller < ActiveRecord::Base

  has_and_belongs_to_many :tours
  has_one :device
end
