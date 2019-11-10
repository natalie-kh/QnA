class AddAcceptedToAnswers < ActiveRecord::Migration[6.0]
  def change
    change_table :answers do |t|
      t.boolean :accepted, default: false

    end

    change_column_null :answers, :accepted, false
  end
end

