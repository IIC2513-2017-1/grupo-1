class AddUserRefToGrands < ActiveRecord::Migration[5.0]
  def change
    add_reference :grands, :user, foreign_key: true
  end
end
