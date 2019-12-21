class VotesTable < ActiveRecord::Migration[6.0]
  def change
    create_table :votes do |t|
      t.integer :value
      t.references :user, null: true, foreign_key: true
      t.references :votable, polymorphic: true

      t.timestamps
    end

    add_index :votes, [:votable_id, :votable_type, :user_id], unique: true
  end
end
