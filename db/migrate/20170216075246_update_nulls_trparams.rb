class UpdateNullsTrparams < ActiveRecord::Migration[5.0]
  def up
    execute("UPDATE public.trparams SET pxx = 0 WHERE pxx is null;")
    execute("UPDATE public.trparams SET pkz = 0 WHERE pkz is null;")
    execute("UPDATE public.trparams SET snom = 1 WHERE snom is null;")
    execute("UPDATE public.trparams SET ukz = 0 WHERE ukz is null;")
    execute("UPDATE public.trparams SET io = 0 WHERE io is null;")
    execute("UPDATE public.trparams SET qkz = 0 WHERE qkz is null;")
    execute("UPDATE public.trparams SET f = true WHERE f is null;")    
  end
  def down
        raise ActiveRecord::IrreversibleMigration
  end 
end
