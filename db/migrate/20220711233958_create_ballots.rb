class CreateBallots < ActiveRecord::Migration[7.0]
  def change
    create_table :ballots do |t|
      t.references :poll_option, null: false, index: true, foreign_key: true

      t.timestamps
    end
  end
end
