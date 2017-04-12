class AddMpoincountToFilial < ActiveRecord::Migration[5.0]
  def change
    add_column :filials, :mpoints_count, :integer
    add_column :furnizors, :mpoints_count, :integer
  end
end
