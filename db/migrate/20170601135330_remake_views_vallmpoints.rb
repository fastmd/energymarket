class RemakeViewsVallmpoints < ActiveRecord::Migration[5.0]
  def up
    execute("DROP VIEW public.vallmpointslnparams;")
    execute("DROP VIEW public.vallmpoints;")
    execute("CREATE OR REPLACE VIEW public.vallmpoints AS
             SELECT t.id,
                t.company_id,
                t.furnizor_id,
                ( SELECT v.filial_id
                       FROM mesubstations v
                      WHERE v.id = t.mesubstation_id) AS filial_id,
                ( SELECT v.region_id
                       FROM mesubstations v
                      WHERE v.id = t.mesubstation_id) AS region_id,
                t.mesubstation_id,
                ( SELECT v.name
                       FROM companies v
                      WHERE t.company_id = v.id) AS company_name,
                ( SELECT v.shname
                       FROM companies v
                      WHERE t.company_id = v.id) AS company_shname,
                ( SELECT v.name
                       FROM furnizors v
                      WHERE v.id = t.furnizor_id) AS furnizor_name,
                ( SELECT f.name
                       FROM mesubstations v,
                        filials f
                      WHERE v.id = t.mesubstation_id AND v.filial_id = f.id) AS filial_name,
                ( SELECT f.cvalue
                       FROM mesubstations v,
                        thesaurus f
                      WHERE v.id = t.mesubstation_id AND v.region_id = f.id) AS region_name,
                ( SELECT v.name
                       FROM mesubstations v
                      WHERE v.id = t.mesubstation_id) AS mesubstation_name,
                t.meconname,
                t.clsstation,
                t.clconname,
                t.name,
                t.cod,
                t.voltcl,
                t.cosfi,
                t.f,
                t.fct,
                t.comment,
                t.created_at,
                t.updated_at
               FROM mpoints t
              ORDER BY t.company_id, t.name;")
    execute("CREATE OR REPLACE VIEW public.vallmpointslnparams AS
             SELECT t1.id,
                t1.company_id,
                t1.furnizor_id,
                t1.filial_id,
                t1.region_id,
                t1.mesubstation_id,
                t1.name,
                t1.cod,
                t1.company_name,
                t1.company_shname,
                t1.furnizor_name,
                t1.filial_name,
                t1.region_name,
                t1.mesubstation_name,
                t1.meconname,
                t1.voltcl,
                t1.cosfi,
                t1.fct,
                t1.f,
                t2.id AS ln_id,
                t2.line_id,
                t2.line_name,
                t2.l,
                t2.r,
                t2.ro,
                t2.k_scr,
                t2.k_tr,
                t2.comment,
                t2.k_peb,
                t2.q,
                t2.k_f,
                t2.mark,
                t2.updated_at,
                t2.f AS ln_f,
                t2.line_f
               FROM vallmpoints t1
                 JOIN valllnparams t2 ON t1.id = t2.mpoint_id
              ORDER BY t1.company_shname, t1.id, t2.id;")    
  end
  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
