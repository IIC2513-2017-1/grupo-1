class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :username
      t.string :role
      t.string :email

      t.timestamps
    end
  end
end
