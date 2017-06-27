class AddApiIdToBets < ActiveRecord::Migration[5.0]
  def change
    add_column :bets, :api_id, :integer
  end
end
