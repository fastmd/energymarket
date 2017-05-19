class AddFlagToMpoints < ActiveRecord::Migration[5.0]
  def change
    add_column :mpoints, :fct, :boolean
  end
end
