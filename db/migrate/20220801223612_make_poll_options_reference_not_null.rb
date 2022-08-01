class MakePollOptionsReferenceNotNull < ActiveRecord::Migration[7.0]
  def change
    change_column_null :poll_options, :poll_id, false
  end
end
