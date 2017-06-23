class AddColFturnToMpoints < ActiveRecord::Migration[5.0]
  def change
    add_column :mpoints, :fturn, :boolean
  end
end
