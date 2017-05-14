class AddFinishToBets < ActiveRecord::Migration[5.0]
  def change
    add_column :bets, :finish, :Boolean
    add_column :bets, :result, :integer
    add_column :bets, :end_date, :datetime
  end
end
