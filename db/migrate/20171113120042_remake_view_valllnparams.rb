class RemakeViewValllnparams < ActiveRecord::Migration[5.0]
  def up
    execute("DROP VIEW public.vallmpointslnparams;")
    execute("DROP VIEW public.valllnparams;")
    execute("CREATE OR REPLACE VIEW public.valllnparams AS
                 SELECT t.id,
                    l.l,
                    l.r,
                    t.mpoint_id,
                    t.created_at,
                    t.updated_at,
                    t.f,
                    t.condate,
                    t.comment,
                    l.filial_id,
                    l.filial_name,
                    l.region_id,
                    l.region_name,
                    l.mesubstation_id,
                    l.mesubstation2_id,
                    l.mesubstation_name,
                    l.mesubstation2_name,
                    l.ro,
                    l.k_scr,
                    l.k_tr,
                    l.k_peb,
                    l.q,
                    l.k_f,
                    l.unom,
                    l.f AS line_f,
                    l.id AS line_id,
                    l.name AS line_name,
                    l.wire_id,
                    l.wire_name,
                    l.wire_name AS mark
                   FROM lnparams t
                     JOIN valllines l ON t.line_id = l.id
                  ORDER BY t.mpoint_id, t.id;") 
    execute("CREATE OR REPLACE VIEW public.vallmpointslnparams AS
                 SELECT t1.id,
                    t1.company_id,
                    t1.furnizor_id,
                    t1.filial_id,
                    t1.region_id,
                    t1.mesubstation_id,
                    t2.mesubstation2_id,
                    t1.name,
                    t1.cod,
                    t1.company_name,
                    t1.company_shname,
                    t1.furnizor_name,
                    t1.filial_name,
                    t1.region_name,
                    t1.mesubstation_name,
                    t2.mesubstation2_name,
                    t1.meconname,
                    t1.voltcl,
                    t1.cosfi,
                    t1.fct,
                    t1.fctc,
                    t1.fctl,
                    t1.f,
                    t1.four,
                    t1.fturn,
                    t1.fmargin,
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
                    t2.unom,
                    t2.updated_at,
                    t2.f AS ln_f,
                    t2.condate,
                    t2.line_f
                   FROM vallmpoints t1
                     JOIN valllnparams t2 ON t1.id = t2.mpoint_id
                  ORDER BY t1.company_shname, t1.id, t2.id;")                                             
  end
  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
