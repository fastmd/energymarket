class DropClientsTable < ActiveRecord::Migration[5.0]
  def up
    drop_table :clients
  end
  def down
    raise ActiveRecord::IrreversibleMigration
  end  
end
