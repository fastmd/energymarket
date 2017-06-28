class UpdateFctlToMpoints < ActiveRecord::Migration[5.0]
  def up
    execute("UPDATE public.mpoints t SET fctl=t.fctc, fctc=null;")                                                 
  end
  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
