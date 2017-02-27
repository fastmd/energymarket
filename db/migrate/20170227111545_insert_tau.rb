class InsertTau < ActiveRecord::Migration[5.0]
  def up
    execute("INSERT INTO public.taus (tm, taum, created_at, updated_at) VALUES (167, 77, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);")
    execute("INSERT INTO public.taus (tm, taum, created_at, updated_at) VALUES (333, 200, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);")
    execute("INSERT INTO public.taus (tm, taum, created_at, updated_at) VALUES (500, 383, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);")
    execute("INSERT INTO public.taus (tm, taum, created_at, updated_at) VALUES (667, 623, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);")
    execute("INSERT INTO public.taus (tm, taum, created_at, updated_at) VALUES (730, 730, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);")
  end
  def down
    raise ActiveRecord::IrreversibleMigration
  end 
end
