class AddPrivateToUserBets < ActiveRecord::Migration[5.0]
  def change
    add_column :user_bets, :private, :boolean
  end
end
