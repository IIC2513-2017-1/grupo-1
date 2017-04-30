class CreateJoinTableGrandsBets < ActiveRecord::Migration[5.0]
  def change
  	create_join_table :grands, :bets do |t|
  	  t.index :grand_id
  	  t.index :bet_id
      t.string :selection
	  end
    add_index :bets_grands, [:grand_id, :bet_id], unique: true
  end
end
