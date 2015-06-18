class Tourguide < ActiveRecord::Base
  belongs_to :company
  has_and_belongs_to_many :tours
  has_one :device
  validates :name,:phone,presence:true
  validates :email, format:{with:/\A[a-zA-Z0-9_.+-]+@[a-zA-Z0-9]+.[a-zA-Z0-9-.]+\z/}

  def self.select
  	#choose tourguide active = false
  	where("active = 0")
  end
  def self.upload(tourguide)
      name = tourguide['images'].original_filename
      directory = "app/assets/images/images_tourguide"
    # create the file path
      path = File.join(directory, name)
    # write the file
      File.open(path, "wb") { |f| f.write(tourguide['images'].read) }
  end
end
