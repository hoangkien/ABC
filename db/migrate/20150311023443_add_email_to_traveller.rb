class AddEmailToTraveller < ActiveRecord::Migration
  def change
    add_column :travellers, :email, :string
  end
end
