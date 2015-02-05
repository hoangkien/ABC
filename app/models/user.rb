class User < ActiveRecord::Base
	GROUP = [:admin, :company]
   	has_secure_password
	validates :account, :password, :password_confirmation, :name,:address, presence: true, on: :create
  validates :account, :name, :address, presence: true, on: :update
	validates :account, uniqueness: true, length: { minimum: 6 }, on: :create
	validates :password , confirmation:true, on: :create

  def self.search(query)
    # where(:title, query) -> This would return an exact match of the query
    where("account like ?", "%#{query}%")
  end

end
