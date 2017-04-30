class CreateBets < ActiveRecord::Migration[5.0]
  def change
    create_table :bets do |t|
      t.string :sport
      t.datetime :start_date
      t.string :country

      t.timestamps
    end
  end
end
