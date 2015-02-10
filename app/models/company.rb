class Company < ActiveRecord::Base
  has_one :user
  require 'securerandom'

  validates :name, :address, presence: true

  def self.generate_company_code
    begin
      code = SecureRandom.hex(6)
    end while Company.find_by_code(code)
    code
  end
  def self.get_all_company
    Company.select(:id,:name)
  end

end
