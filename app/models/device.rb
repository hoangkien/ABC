class Device < ActiveRecord::Base
  belongs_to :tourguide
  belongs_to :traveller
  belongs_to :company
  has_one :feedback
  def self.search(query,company_id = nil)
  	if company_id
  		where("1=1 and name like ? and company_id = ? ","%#{query}%","#{company_id}")	
  	else
  		where("name like ? or id = ?","%#{query}%","#{query}")	
  	end
  end
  def self.search_active_o
  	where("status = 0")
  end
end
