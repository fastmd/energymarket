class RemakeViewsMpointslnparams < ActiveRecord::Migration[5.0]
  def up
    execute("CREATE OR REPLACE VIEW public.vmpointslnparams AS
             SELECT t1.id,
                    t1.company_id,
                    t1.furnizor_id,
                    t1.filial_id,
                    t1.region_id,
                    t1.mesubstation_id,
                    t1.name,
                    t1.cod,
                    t1.company,
                    t1.furnizor,
                    t1.filial,
                    t1.region,
                    t1.mesubstation,
                    t1.meconname,
                    t1.voltcl,
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
                    t2.f ln_f,
                    t2.line_f                 
                   FROM vmpoints t1
                     JOIN vlnparams t2 ON t1.id = t2.mpoint_id
                  ORDER BY t1.company, t1.id, t2.id;")
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
                    t2.f ln_f,
                    t2.line_f 
                   FROM vallmpoints t1
                     JOIN valllnparams t2 ON t1.id = t2.mpoint_id
                  ORDER BY t1.company_shname, t1.id, t2.id;")                                                                               
  end
  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
