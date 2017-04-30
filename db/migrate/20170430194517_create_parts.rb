class CreateParts < ActiveRecord::Migration[5.0]
  def change
    create_table :parts do |t|
      t.integer :competitor_id
      t.integer :bet_id
      t.float :multiplicator
      t.integer :local

      t.timestamps
    end
    add_index :parts, [:competitor_id, :bet_id], unique: true
  end
end
