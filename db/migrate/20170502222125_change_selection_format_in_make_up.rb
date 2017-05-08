class ChangeSelectionFormatInMakeUp < ActiveRecord::Migration[5.0]
  def change
    remove_column :make_ups, :selection, :string
    add_column :make_ups, :selection, :integer
  end
end
