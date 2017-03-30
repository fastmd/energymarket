class InsertThesaurus < ActiveRecord::Migration[5.0]
  def up
    execute("INSERT INTO public.thesaurus (category, name, cvalue, f, created_at, updated_at) VALUES (1, 'meter', 'A1RLQ',true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);")
    execute("INSERT INTO public.thesaurus (category, name, cvalue, f, created_at, updated_at) VALUES (2, 'meter', 'ZMD-405',true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);")
    execute("INSERT INTO public.thesaurus (category, name, cvalue, f, created_at, updated_at) VALUES (3, 'meter', 'ZMD-410',true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);")
    execute("INSERT INTO public.thesaurus (category, name, cvalue, f, created_at, updated_at) VALUES (4, 'meter', 'MT831-T1',true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);")
    execute("INSERT INTO public.thesaurus (category, name, cvalue, f, created_at, updated_at) VALUES (5, 'meter', 'САУЗИ-И670',true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);")
    execute("INSERT INTO public.thesaurus (category, name, cvalue, f, created_at, updated_at) VALUES (6, 'meter', 'MT-831-T1A32R46S43-E2',true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);")
  end
  def down
    raise ActiveRecord::IrreversibleMigration
  end 
end
