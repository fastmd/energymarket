class UpdateMvaluesR < ActiveRecord::Migration[5.0]
  def up
    execute("UPDATE public.mvalues SET r = true WHERE r is null;")    
  end
  def down
    raise ActiveRecord::IrreversibleMigration
  end 
end
