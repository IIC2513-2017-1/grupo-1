class CreateMakeUps < ActiveRecord::Migration[5.0]
  def change
    create_table :make_ups do |t|
      t.integer :bet_id
      t.integer :grand_id
      t.string :selection

      t.timestamps
    end
  end
end
