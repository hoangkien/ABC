class Traveller < ActiveRecord::Base
  has_and_belongs_to_many :tours
  belongs_to :company
  has_one :device
  validates :name,:phone, presence:true
  def self.search(query,company_id = nil)
  	if company_id
  		where("1=1 and name like ? and company_id = ? ","%#{query}%","#{company_id}")	
  	else
  		where("1=1 and name like ? ","%#{query}%")	
  	end
  end
   def self.upload(traveller)
      name = traveller['images'].original_filename
      directory = "app/assets/images/images_travellers"
    # create the file path
      path = File.join(directory, name)
    # write the file
      File.open(path, "wb") { |f| f.write(traveller['images'].read) }
  end
end
