class CreateDecidedNames < ActiveRecord::Migration[8.0]
  def change
    create_table :decided_names do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :name, null: false, foreign_key: true
      t.boolean :decision, null: false

      t.timestamps
    end
  end
end
