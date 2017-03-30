class InsertRegionToThesaurus < ActiveRecord::Migration[5.0]
  def up
    execute("INSERT INTO public.thesaurus ( name, cvalue, f, created_at, updated_at) 
               (SELECT 'region' as name, t.*, true as f, CURRENT_TIMESTAMP as created_at, CURRENT_TIMESTAMP as updated_at  FROM (
                     SELECT  distinct c.shname cvalue FROM public.companies c WHERE ( SELECT f.NAME FROM public.furnizors f WHERE  f.id = c.furnizor_id )  LIKE '%FEE%' ) t);")
    execute("CREATE OR REPLACE VIEW VREGIONS AS SELECT T.ID,T.CVALUE FROM thesaurus T WHERE  t.name='region' and T.F = TRUE ORDER BY T.CVALUE, T.CREATED_AT;")                        
  end
  def down
    raise ActiveRecord::IrreversibleMigration
  end 
end
