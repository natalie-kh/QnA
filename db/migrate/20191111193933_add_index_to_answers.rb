class AddIndexToAnswers < ActiveRecord::Migration[6.0]
  def change
    add_index :answers, [:question_id, :accepted], unique: true, where: "accepted = true"
  end
end
