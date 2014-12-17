class CreateMoves < ActiveRecord::Migration
  def change
    create_table :moves do |t|
      t.integer :user_id
      t.integer :match_id
      t.integer :square_id
      t.integer :value

      t.timestamps
    end
  end
end
