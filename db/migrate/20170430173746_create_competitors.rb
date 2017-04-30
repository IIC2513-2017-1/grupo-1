class CreateCompetitors < ActiveRecord::Migration[5.0]
  def change
    create_table :competitors do |t|
      t.string :name
      t.string :country
      t.string :sport

      t.timestamps
    end
  end
end
