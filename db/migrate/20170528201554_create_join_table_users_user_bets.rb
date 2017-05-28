class CreateJoinTableUsersUserBets < ActiveRecord::Migration[5.0]
  def change
    create_join_table :users, :user_bets do |t|
      t.references :user, foreign_key: true
      t.references :user_bet, foreign_key: true
    end
  end
end
