class AddApiIdToCompetitors < ActiveRecord::Migration[5.0]
  def change
    add_column :competitors, :api_id, :integer
  end
end
