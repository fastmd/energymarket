class UpdateNulls < ActiveRecord::Migration[5.0]
  def up
    execute("UPDATE public.companies SET name = 'потребитель' WHERE name is null;")
    execute("UPDATE public.companies SET shname = 'потребитель' WHERE shname is null;")
    execute("UPDATE public.companies SET f = true WHERE f is null;")    
    execute("UPDATE public.filials SET name = 'филиал' WHERE name is null;")
    execute("UPDATE public.furnizors SET name = 'поставщик' WHERE name is null;")
    execute("UPDATE public.mesubstations SET name = 'подстанция' WHERE name is null;")
  end
  def down
        raise ActiveRecord::IrreversibleMigration
  end 
end
