class DeleteSstationsFromThesaurus < ActiveRecord::Migration[5.0]
  def up
    execute("DROP VIEW public.vsstations;")
    execute("DELETE FROM public.thesaurus WHERE name = 'sstation';")                       
  end
  def down
    raise ActiveRecord::IrreversibleMigration
  end 
end
