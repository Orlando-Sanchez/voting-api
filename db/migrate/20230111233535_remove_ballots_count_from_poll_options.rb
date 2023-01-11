class RemoveBallotsCountFromPollOptions < ActiveRecord::Migration[7.0]
  def change
    remove_column :poll_options, :ballots_count, :integer
  end
end
