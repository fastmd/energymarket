class AddIndex < ActiveRecord::Migration[5.0]
  def change
    add_index :mvalues, :actdate
    add_index :mvalues, [:meter_id, :actdate]
    add_index :meters, :relevance_date
    add_index :meters, [:mpoint_id, :relevance_date]
  end
end
