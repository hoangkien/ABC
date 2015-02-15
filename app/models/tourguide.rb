class Tourguide < ActiveRecord::Base

  has_and_belongs_to_many :tours
  has_one :device
  def self.search(query)
    # where(:title, query) -> This would return an exact match of the query
    where("name like ?", "%#{query}%")
  end
  def self.select
  	#choose tourguide active = false
  	where("active = 0")
  end
end
