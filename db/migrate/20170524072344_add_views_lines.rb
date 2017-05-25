class AddViewsLines < ActiveRecord::Migration[5.0]
  def up  
    execute("CREATE OR REPLACE VIEW public.vlines AS
             SELECT t.id,
                t.name,
                ( SELECT v.filial_id
                       FROM mesubstations v
                      WHERE v.id = t.mesubstation_id) AS filial_id,
                ( SELECT v.region_id
                       FROM mesubstations v
                      WHERE v.id = t.mesubstation_id) AS region_id,
                t.mesubstation_id,
                t.wire_id,
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
                t.l,
                t.r,
                t.k_tr,
                t.k_f,
                t.f,
                t.comment,
                t.created_at,
                t.updated_at,
                w.name wire_name,
                w.ro,
                w.k_scr,
                w.k_peb,
                w.q,
                w.f wire_f,
                w.comment wire_comment
               FROM lines t left outer join wires w on t.wire_id=w.id 
              WHERE t.f = true
              ORDER BY t.mesubstation_id, t.id;")
    execute("CREATE OR REPLACE VIEW public.valllines AS
             SELECT t.id,
                t.name,
                ( SELECT v.filial_id
                       FROM mesubstations v
                      WHERE v.id = t.mesubstation_id) AS filial_id,
                ( SELECT v.region_id
                       FROM mesubstations v
                      WHERE v.id = t.mesubstation_id) AS region_id,
                t.mesubstation_id,
                t.wire_id,
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
                t.l,
                t.r,
                t.k_tr,
                t.k_f,
                t.f,
                t.comment,
                t.created_at,
                t.updated_at,
                w.name wire_name,
                w.ro,
                w.k_scr,
                w.k_peb,
                w.q,
                w.f wire_f,
                w.comment wire_comment
               FROM lines t left outer join wires w on t.wire_id=w.id 
              ORDER BY t.mesubstation_id, t.id;")                                                              
  end
  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
