class AddMpointsColumn < ActiveRecord::Migration[5.0]
  def change
    add_column :mpoints, :comment, :text
  end
end
