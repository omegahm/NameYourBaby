class CreateNames < ActiveRecord::Migration[8.0]
  def change
    create_table :names do |t|
      t.string :name, null: false, index: { unique: true }
      t.string :gender, null: false

      t.timestamps
    end
  end
end
