class AddDrawsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :draws, :integer
  end
end
