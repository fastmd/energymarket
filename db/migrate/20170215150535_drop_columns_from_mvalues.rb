class DropColumnsFromMvalues < ActiveRecord::Migration[5.0]
  def change
    remove_column :mvalues, :vnum, :integer
    remove_column :mvalues, :val, :float
    remove_column :mpoints, :pnum, :integer
    remove_column :mpoints, :pname, :string
  end
end
