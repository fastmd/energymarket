class MoveDataMvaluesFromDwaToUndercount < ActiveRecord::Migration[5.0]
  def up
    execute("Update public.mvalues set undercount=abs(dwa) where dwa is not null and dwa < 0; ")
    execute("Update public.mvalues set dwa=null where dwa is not null and dwa < 0; ")               
  end
  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
