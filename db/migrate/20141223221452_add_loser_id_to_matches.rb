class AddLoserIdToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :loser_id, :integer
  end
end
