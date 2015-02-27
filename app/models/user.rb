
class User < ActiveRecord::Base
  require'digest/md5'
  belongs_to :company, dependent: :destroy
	GROUP = [:admin, :company]
  before_create :md5   
  validates :account, :password, :password_confirmation, :name,:address, presence: true, on: :create
  validates :account, :name, :address, presence: true, on: :update
  validates :account, uniqueness: true, length: { minimum: 6 }, on: :create
  validates :password , confirmation:true, on: :create
  validates :account,:password, format: { with: /\A[a-zA-Z0-9]+\z/, message: " is invalid"} ,on: :create
  def self.search(query)
    # where(:title, query) -> This would return an exact match of the query
    where("account like ? or name like ? or address like ?", "%#{query}%","%#{query}%","%#{query}%")
  end
  private
  def md5
      self.password = Digest::MD5.hexdigest(password)
  end
  def self.login(account, pass)
    where("account like ? and password like ?","#{account}","#{pass}").first
  end

end
