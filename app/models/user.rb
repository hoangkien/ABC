class User < ActiveRecord::Base
   	has_secure_password
	validates :account, :password, :password_confirmation, :name,:address, presence: true
	validates :account, uniqueness: true, length: { minimum: 8 }
	validates :password , confirmation:true

end
