class UpdateActpMvalues < ActiveRecord::Migration[5.0]
  def up
    execute("UPDATE public.mvalues SET actp180 = 0 WHERE actp180 is null;")
    execute("UPDATE public.mvalues SET actp280 = 0 WHERE actp280 is null;")
    execute("UPDATE public.mvalues SET actp380 = 0 WHERE actp380 is null;")
    execute("UPDATE public.mvalues SET actp480 = 0 WHERE actp480 is null;")
    execute("UPDATE public.mvalues SET actdate = '01/01/2016' WHERE actdate is null;")
    execute("UPDATE public.mvalues SET f = true WHERE f is null;")    
  end
  def down
        raise ActiveRecord::IrreversibleMigration
  end    
end
