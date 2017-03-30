class ChangeColDefaultMpoints < ActiveRecord::Migration[5.0]
  def change
    change_column_default(:mpoints, :messtation, nil)
    change_column_default(:mpoints, :meconname, nil)
    change_column_default(:mpoints, :clsstation, nil)
    change_column_default(:mpoints, :clconname, nil)
    change_column_default(:mpoints, :name, nil)
  end
end
