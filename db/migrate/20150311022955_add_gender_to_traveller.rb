class AddGenderToTraveller < ActiveRecord::Migration
  def change
    add_column :travellers, :gender, :tinyint
  end
end
