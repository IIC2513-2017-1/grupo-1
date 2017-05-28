class AddIndexToUserUserBets < ActiveRecord::Migration[5.0]
  def change
    add_index :user_bets_users, %i[user_id user_bet_id], unique: true
  end
end
