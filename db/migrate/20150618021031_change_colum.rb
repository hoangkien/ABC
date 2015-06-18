class ChangeColum < ActiveRecord::Migration
  def change
    if column_exists?(:users,:company_id)
      remove_column :users, :company_id
    end
    add_column :companies, :user_id, :integer
  end
end
