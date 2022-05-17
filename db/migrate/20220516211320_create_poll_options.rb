class CreatePollOptions < ActiveRecord::Migration[7.0]
  def change
    create_table :poll_options do |t|
      t.text :title, null: false
      t.references :poll, index: true, foreign_key: {on_delete: :cascade, on_update: :cascade}

      t.timestamps
    end
  end
end
