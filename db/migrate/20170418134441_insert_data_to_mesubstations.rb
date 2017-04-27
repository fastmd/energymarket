class InsertDataToMesubstations < ActiveRecord::Migration[5.0]
  def up
    execute("INSERT INTO public.mesubstations (name, f, created_at, updated_at) 
               (SELECT ss.cvalue as name, true as f, CURRENT_TIMESTAMP as created_at, CURRENT_TIMESTAMP as updated_at  FROM (
                     SELECT c.cvalue   FROM public.thesaurus c  where c.name='sstation') ss );")                        
  end
  def down
    raise ActiveRecord::IrreversibleMigration
  end 
end
