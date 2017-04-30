class AddPayPerTieToBets < ActiveRecord::Migration[5.0]
  def change
    add_column :bets, :pay_per_tie, :float
  end
end
