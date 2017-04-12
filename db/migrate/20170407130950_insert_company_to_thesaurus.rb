class InsertCompanyToThesaurus < ActiveRecord::Migration[5.0]
  def up
    execute("INSERT INTO public.thesaurus ( name, cvalue, shcvalue, f, created_at, updated_at) 
               (SELECT 'company' as name, t.cvalue, t.shcvalue, true as f, CURRENT_TIMESTAMP as created_at, CURRENT_TIMESTAMP as updated_at  FROM (
                     SELECT  distinct trim(c.name) cvalue, trim(c.shname) shcvalue FROM public.companies c ) t);")
    execute("CREATE OR REPLACE VIEW VCOMPANIES AS SELECT T.ID,T.CVALUE,T.SHCVALUE FROM thesaurus T WHERE  t.name='company' and T.F = TRUE ORDER BY T.CVALUE, T.CREATED_AT;")                        
  end
  def down
    raise ActiveRecord::IrreversibleMigration
  end 
end
