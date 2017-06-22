class RenameF280FourtrToMpoints < ActiveRecord::Migration[5.0]
  def change
    rename_column :mpoints, :f280, :four
  end
end
