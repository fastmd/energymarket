class UpdateCondateLnparams < ActiveRecord::Migration[5.0]
  def up
    execute("UPDATE public.lnparams SET CONDATE='01/01/2016' where CONDATE IS NULL;")                                       
  end
  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
