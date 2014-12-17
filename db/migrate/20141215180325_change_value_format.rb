class ChangeValueFormat < ActiveRecord::Migration
  def change
    change_column :moves, :value, :string
  end
end
