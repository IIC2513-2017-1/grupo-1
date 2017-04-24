class CreateUserUserBets < ActiveRecord::Migration[5.0]
  def change
    create_table :user_user_bets, id: false do |t|
      t.references :user, foreign_key: true
      t.references :user_bet, foreign_key: true
    end
  end
end
