class RemakeViewsLnparams < ActiveRecord::Migration[5.0]
  def up
    execute("DROP VIEW vmpointslnparams;")
    execute("DROP VIEW vlnparams;")  
    execute("CREATE OR REPLACE VIEW public.vlnparams AS
             SELECT t.id,
                    l.l,
                    l.r,
                    t.mpoint_id,
                    t.created_at,
                    t.updated_at,
                    t.f,
                    t.comment,
                    l.filial_id,
                    l.filial_name,
                    l.region_id,
                    l.region_name,
                    l.ro,
                    l.k_scr,
                    l.k_tr,
                    l.k_peb,
                    l.q,
                    l.k_f,
                    l.f line_f,
                    l.id line_id,
                    l.name line_name,
                    l.wire_id,
                    l.wire_name,
                    l.wire_name mark
                   FROM lnparams t inner join valllines l on t.line_id=l.id 
                  WHERE t.f = true
                  ORDER BY t.mpoint_id, t.id;")
     execute("CREATE OR REPLACE VIEW public.valllnparams AS
             SELECT t.id,
                    l.l,
                    l.r,
                    t.mpoint_id,
                    t.created_at,
                    t.updated_at,
                    t.f,
                    t.comment,
                    l.filial_id,
                    l.filial_name,
                    l.region_id,
                    l.region_name,
                    l.ro,
                    l.k_scr,
                    l.k_tr,
                    l.k_peb,
                    l.q,
                    l.k_f,
                    l.f line_f,
                    l.id line_id,
                    l.name line_name,
                    l.wire_id,
                    l.wire_name,
                    l.wire_name mark
                   FROM lnparams t inner join valllines l on t.line_id=l.id 
                  ORDER BY t.mpoint_id, t.id;")                                                                                              
  end
  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
