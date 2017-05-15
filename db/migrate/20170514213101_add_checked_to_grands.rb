class AddCheckedToGrands < ActiveRecord::Migration[5.0]
  def change
    add_column :grands, :checked, :Boolean
  end
end
