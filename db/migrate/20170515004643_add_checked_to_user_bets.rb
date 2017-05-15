class AddCheckedToUserBets < ActiveRecord::Migration[5.0]
  def change
    add_column :user_bets, :checked, :Boolean
  end
end
