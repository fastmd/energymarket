class AddFmarginToMpoints < ActiveRecord::Migration[5.0]
  def change
    add_column :mpoints, :fmargin, :boolean
  end
end
