class CreateJoinTableBetsCompetitors < ActiveRecord::Migration[5.0]
  def change
  	create_join_table :competitors, :bets do |t|
  	  t.index :competitor_id
  	  t.index :bet_id
      t.float :multiplicator
      t.integer :local
	  end
    add_index :bets_competitors, [:competitor_id, :bet_id], unique: true
  end
end
