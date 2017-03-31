class InsertThesaurus4 < ActiveRecord::Migration[5.0]
  def up
    execute("INSERT INTO public.thesaurus (name, cvalue, f, created_at, updated_at) VALUES ('meter', 'MT831-T',true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);")
  end
  def down
    raise ActiveRecord::IrreversibleMigration
  end 
end
