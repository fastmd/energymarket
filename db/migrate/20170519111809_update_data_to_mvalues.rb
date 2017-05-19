class UpdateDataToMvalues < ActiveRecord::Migration[5.0]
  def up
    execute("UPDATE public.mvalues SET actp380 = actp580 WHERE (actp380 is null or actp380 = 0) and actp580 is not null;")
    execute("UPDATE public.mvalues SET actp480 = actp880 WHERE (actp480 is null or actp480 = 0) and actp880 is not null;")
    execute("UPDATE public.mvalues SET actp180 = 0 WHERE (actp180 is null);")
    execute("UPDATE public.mvalues SET actp280 = 0 WHERE (actp280 is null);") 
    execute("UPDATE public.mvalues SET actp380 = 0 WHERE (actp380 is null);")  
    execute("UPDATE public.mvalues SET actp480 = 0 WHERE (actp480 is null);")                                                
  end
  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
