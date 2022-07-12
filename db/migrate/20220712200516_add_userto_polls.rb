class AddUsertoPolls < ActiveRecord::Migration[7.0]
  def change
    add_reference :polls, :user, null: false, index: true, foreign_key: true
  end
end
