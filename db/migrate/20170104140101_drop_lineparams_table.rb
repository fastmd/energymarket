class DropLineparamsTable < ActiveRecord::Migration[5.0]
  def up
    drop_table :lineparams
  end
  def down
    raise ActiveRecord::IrreversibleMigration
  end   
end
