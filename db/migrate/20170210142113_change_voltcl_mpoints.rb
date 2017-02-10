class ChangeVoltclMpoints < ActiveRecord::Migration[5.0]
  def change
    remove_column :mpoints, :voltcl, :string
    add_column :mpoints, :voltcl, :integer, null: false, default: 10
  end
end
