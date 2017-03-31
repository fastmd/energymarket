class InsertThesaurus3 < ActiveRecord::Migration[5.0]
  def up
    execute("INSERT INTO public.thesaurus (name, cvalue, f, created_at, updated_at) VALUES ('meter', 'ZMG-405',true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);")
  end
  def down
    raise ActiveRecord::IrreversibleMigration
  end 
end
