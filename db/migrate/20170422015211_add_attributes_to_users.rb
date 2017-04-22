class AddAttributesToUsers < ActiveRecord::Migration[5.0]
  def change
    change_table :users do |t|
      t.string :name, :lastname, :description
      t.integer :money
      t.date :birthday
    end

    add_index :users, :username, unique: true
  end
end
