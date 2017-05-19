class ChViewsToMpoints < ActiveRecord::Migration[5.0]
  def up
    execute("DROP VIEW vallmpoints;")
    execute("CREATE OR REPLACE VIEW public.vallmpoints AS
             SELECT   t.id,
                      t.company_id,
                      t.furnizor_id,
                      (SELECT v.filial_id FROM public.mesubstations v WHERE v.id = t.mesubstation_id) AS filial_id,
                      (SELECT v.region_id FROM public.mesubstations v WHERE v.id = t.mesubstation_id) AS region_id,
                      t.mesubstation_id,
                      (select v.name from public.companies v where t.company_id = v.id) AS company_name,
                      (select v.shname from public.companies v where t.company_id = v.id) AS company_shname,
                      (SELECT v.name FROM public.furnizors v WHERE v.id = t.furnizor_id) AS furnizor_name,   
                      (SELECT f.name FROM public.mesubstations v, public.filials f WHERE v.id = t.mesubstation_id and v.filial_id = f.id) AS filial_name,
                      (SELECT f.cvalue FROM public.mesubstations v, public.thesaurus f WHERE v.id = t.mesubstation_id and v.region_id = f.id) AS region_name, 
                      (SELECT v.name FROM public.mesubstations v WHERE v.id = t.mesubstation_id) AS mesubstation_name,
                      t.meconname,
                      t.clsstation,
                      t.clconname,
                      t.name,
                      t.cod,
                      t.voltcl,
                      t.f,
                      t.fct,
                      t.comment,
                      t.created_at,
                      t.updated_at
                     FROM public.mpoints t
                    ORDER BY t.company_id, t.name;")                                
  end
  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
