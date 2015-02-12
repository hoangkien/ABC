class Device < ActiveRecord::Base
  belongs_to :tourguide
  belongs_to :traveller
  has_one :feedback
  def self.search(query)
  	where("name like ?","%#{query}%")	
  end
end
