class UpdateNullsLnparams < ActiveRecord::Migration[5.0]
  def up
    execute("UPDATE public.lnparams SET l = 0 WHERE l is null;")
    execute("UPDATE public.lnparams SET r = 0 WHERE r is null;")
    execute("UPDATE public.lnparams SET ro = 0 WHERE ro is null;")
    execute("UPDATE public.lnparams SET k_scr = 0 WHERE k_scr is null;")
    execute("UPDATE public.lnparams SET k_tr = 0 WHERE k_tr is null;")
    execute("UPDATE public.lnparams SET k_peb = 0 WHERE k_peb is null;")
    execute("UPDATE public.lnparams SET q = 1 WHERE q is null;")
    execute("UPDATE public.lnparams SET k_f = 0 WHERE k_f is null;")
    execute("UPDATE public.lnparams SET f = true WHERE f is null;")    
  end
  def down
        raise ActiveRecord::IrreversibleMigration
  end 
end
