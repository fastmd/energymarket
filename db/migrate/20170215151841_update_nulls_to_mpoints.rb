class UpdateNullsToMpoints < ActiveRecord::Migration[5.0]
  def up
    execute("UPDATE public.mpoints SET name = 'точка учета' WHERE name is null;")
    execute("UPDATE public.mpoints SET messtation = 'подстанция МЭ' WHERE messtation is null;")
    execute("UPDATE public.mpoints SET meconname = 'фидер МЭ' WHERE meconname is null;")
    execute("UPDATE public.mpoints SET clsstation = 'подстанция клиента' WHERE clsstation is null;")
    execute("UPDATE public.mpoints SET clconname = 'фидер клиента' WHERE clconname is null;")
    execute("UPDATE public.mpoints SET f = true WHERE f is null;")    
  end
  def down
        raise ActiveRecord::IrreversibleMigration
  end
end
