class AddResultToUserBets < ActiveRecord::Migration[5.0]
  def change
    add_column :user_bets, :result, :integer
  end
end
