class Change1VoltclMpoints < ActiveRecord::Migration[5.0]
  def change
    remove_column :mpoints, :voltcl, :integer, null: false, default: 10
    add_column :mpoints, :voltcl, :float, null: false, default: 10
  end
end
