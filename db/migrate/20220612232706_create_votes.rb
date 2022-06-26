class CreateVotes < ActiveRecord::Migration[7.0]
  def change
    create_table :votes do |t|
      t.references :user, index: true, foreign_key: {on_update: :cascade}
      t.references :poll, index: true, foreign_key: {on_delete: :cascade, on_update: :cascade}

      t.timestamps
    end
  end
end
