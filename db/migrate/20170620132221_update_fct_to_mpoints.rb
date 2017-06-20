class UpdateFctToMpoints < ActiveRecord::Migration[5.0]
  def up
    execute("UPDATE public.mpoints t SET fct=not(t.fct);")                                                 
  end
  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
