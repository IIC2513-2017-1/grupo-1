class AddEndDateToGrands < ActiveRecord::Migration[5.0]
  def change
    add_column :grands, :end_date, :datetime
  end
end
