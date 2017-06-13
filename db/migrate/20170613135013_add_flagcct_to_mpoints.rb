class AddFlagcctToMpoints < ActiveRecord::Migration[5.0]
  def change
    add_column :mpoints, :fctc, :boolean
  end
end
