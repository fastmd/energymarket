class InsertSstationToThesaurus < ActiveRecord::Migration[5.0]
  def up
    execute("INSERT INTO public.thesaurus ( name, cvalue, f, created_at, updated_at) 
               (SELECT 'sstation' as name, t.*, true as f, CURRENT_TIMESTAMP as created_at, CURRENT_TIMESTAMP as updated_at  FROM (
                     SELECT  distinct trim(c.messtation) cvalue FROM public.mpoints c ) t);")
    execute("CREATE OR REPLACE VIEW VSSTATIONS AS SELECT T.ID,T.CVALUE FROM thesaurus T WHERE  t.name='sstation' and T.F = TRUE ORDER BY T.CVALUE, T.CREATED_AT;")                        
  end
  def down
    raise ActiveRecord::IrreversibleMigration
  end 
end
