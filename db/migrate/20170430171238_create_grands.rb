class CreateGrands < ActiveRecord::Migration[5.0]
  def change
    create_table :grands do |t|
      t.integer :amount

      t.timestamps
    end
  end
end
