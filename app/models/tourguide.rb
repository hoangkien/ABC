class Tourguide < ActiveRecord::Base

  has_and_belongs_to_many :tours
  has_one :device
  def self.search(query,company_id = nil)
    if company_id
      where("1=1 and name like ? and company_id = ? ","%#{query}%","#{company_id}") 
    else
      where("1=1 and name like ? ","%#{query}%")  
    end
  end
  def self.select
  	#choose tourguide active = false
  	where("active = 0")
  end
end
