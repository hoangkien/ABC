class AddGenderToTourguide < ActiveRecord::Migration
  def change
    add_column :tourguides, :gender, :tinyint
  end
end
