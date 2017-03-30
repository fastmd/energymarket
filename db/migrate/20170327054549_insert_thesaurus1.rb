class InsertThesaurus1 < ActiveRecord::Migration[5.0]
  def up
    execute("INSERT INTO public.thesaurus (category, name, cvalue, f, created_at, updated_at) VALUES (7, 'meter', 'A1RLQ+',true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);")
    execute("INSERT INTO public.thesaurus (category, name, cvalue, f, created_at, updated_at) VALUES (8, 'meter', 'MT831-T1A',true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);")
  end
  def down
    raise ActiveRecord::IrreversibleMigration
  end 
end
