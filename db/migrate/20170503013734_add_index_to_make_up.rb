class AddIndexToMakeUp < ActiveRecord::Migration[5.0]
  def change
    add_index :make_ups, [:grand_id, :bet_id], unique: true
  end
end
