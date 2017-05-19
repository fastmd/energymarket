class Add1FlagToMpoints < ActiveRecord::Migration[5.0]
  def up 
    execute("UPDATE public.mpoints SET fct = true;")                                                
  end
  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
