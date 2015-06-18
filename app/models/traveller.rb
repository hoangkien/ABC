class Traveller < ActiveRecord::Base
  has_and_belongs_to_many :tours
  belongs_to :company
  has_one :device
  validates :name,:phone, presence:true

  scope :fillter, -> (key,value){ where("#{key} like '%#{value}%'")}
  scope :fillter_active, ->(active){ return if active == 'All'
                                      where("active = #{active}")
                                     }
   def self.upload(traveller)
      name = traveller['images'].original_filename
      directory = "app/assets/images/images_travellers"
    # create the file path
      path = File.join(directory, name)
    # write the file
      File.open(path, "wb") { |f| f.write(traveller['images'].read) }
  end
end
