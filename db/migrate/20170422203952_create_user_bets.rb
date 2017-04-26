class CreateUserBets < ActiveRecord::Migration[5.0]
  def change
    create_table :user_bets do |t|
      t.string :name
      t.string :description
      t.belongs_to :user, index: true
      t.integer :challenger_amount
      t.integer :gambler_amount
      t.integer :bet_limit
      t.datetime :start_date
      t.datetime :end_date

      t.timestamps
    end
  end
end
