class MakeVotesReferencesNotNull < ActiveRecord::Migration[7.0]
  def change
    change_column_null :votes, :poll_id, false
    change_column_null :votes, :user_id, false
  end
end
