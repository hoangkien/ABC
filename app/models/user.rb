
class User < ActiveRecord::Base
  require'digest/md5'
  has_one :company, dependent: :destroy
  accepts_nested_attributes_for :company
	GROUP = [:admin, :company]
  has_secure_password
  validates :account,:password_digest, :name,:address, presence: true, on: :create
  validates :account, :name, :address, presence: true, on: :update
  validates :account, uniqueness: true, length: { minimum: 6 }, on: :create
  # validates :account,:password, format: { with: /\A[a-zA-Z0-9]+\z/, message: " is invalid"} ,on: :create
  scope :find_scope, -> (key,value){ return if value.blank?
                                      where("#{key} like '%#{value}%'")
                                     }
  scope :find_group, ->(group) { return if  group == 'All'
                                            where("users.group = '#{group}'")}
  scope :find_created, ->(created_at) {return if  created_at == 'All'
                                                      where("created_at > '#{created_at}'")}

  private
  def self.login(account, pass)
    where("account like ? and password like ?","#{account}","#{pass}").first
  end
end
