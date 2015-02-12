
class User < ActiveRecord::Base
  require'digest/md5'
  belongs_to :company
	GROUP = [:admin, :company]
  after_validation :md5
	validates :account, :password, :password_confirmation, :name,:address, presence: true
  validates :account, :name, :address, presence: true, on: :update
	validates :account, uniqueness: true, length: { minimum: 6 }, on: :create
	validates :password , confirmation:true
  def self.search(query)
    # where(:title, query) -> This would return an exact match of the query
    where("account like ?", "%#{query}%")
  end
  private
  def md5
      self.password = Digest::MD5.hexdigest(password)
  end
  def self.login(account, pass)
    where("account like ? and password like ?","#{account}","#{pass}").first
  end

end
