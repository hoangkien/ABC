class Tour < ActiveRecord::Base

  has_and_belongs_to_many :travellers
  has_and_belongs_to_many :tourguides
  def self.search(query)
  	where("name like ? or information like ?","%#{query}%","%#{query}%")
  end
end
