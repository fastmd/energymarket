class AddMpointColCount < ActiveRecord::Migration[5.0]
  def change
    add_column :mpoints, :name, :string
  end
end
