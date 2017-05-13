class AddTournamentToBets < ActiveRecord::Migration[5.0]
  def change
    add_column :bets, :tournament, :string
  end
end
