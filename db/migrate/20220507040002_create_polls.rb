class CreatePolls < ActiveRecord::Migration[7.0]
  def change
    create_table :polls do |t|
      t.text :subject, null: false

      t.timestamps
    end
  end
end
