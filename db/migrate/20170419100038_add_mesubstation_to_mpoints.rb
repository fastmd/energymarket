class AddMesubstationToMpoints < ActiveRecord::Migration[5.0]
    add_column :mpoints, :mesubstation_id, :integer
    add_foreign_key :mpoints, :mesubstations
    add_index :mpoints, :mesubstation_id
end
