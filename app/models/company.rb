class Company < ActiveRecord::Base
  require 'securerandom'

  before_create :generate_code
  def generate_code
    # params[:code] = Company.generate_company_code
  end

  def self.generate_company_code
    begin
      code = SecureRandom.hex(6)
    end while Company.find_by_code(code)
    code
  end

end
