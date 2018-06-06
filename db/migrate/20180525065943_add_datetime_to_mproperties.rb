class AddDatetimeToMproperties < ActiveRecord::Migration[5.0]
  def change
    add_column(:mproperties, :propdate, :datetime)
    change_column_null(:mproperties, :propdate, false)    
  end
end
