class AddBallotsCountToPollOptions < ActiveRecord::Migration[7.0]
  def change
    add_column :poll_options, :ballots_count, :integer
  end
end
