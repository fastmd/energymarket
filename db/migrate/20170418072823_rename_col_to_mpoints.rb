class RenameColToMpoints < ActiveRecord::Migration[5.0]
  def change
    rename_column :companies, :region, :cod
    remove_column :mpoints, :mess_id, :integer
  end
end
