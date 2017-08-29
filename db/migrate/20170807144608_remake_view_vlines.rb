class RemakeViewVlines < ActiveRecord::Migration[5.0]
  def up
    execute("DROP VIEW public.vlines;")
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
                  t.mesubstation2_id,
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
                  ( SELECT v.name
                         FROM mesubstations v
                        WHERE v.id = t.mesubstation2_id) AS mesubstation2_name,      
                  t.l,
                  t.r,
                  t.k_tr,
                  t.k_f,
                  t.unom,
                  t.f,
                  t.comment,
                  t.created_at,
                  t.updated_at,
                  w.name AS wire_name,
                  w.ro,
                  w.k_scr,
                  w.k_peb,
                  w.q,
                  w.f AS wire_f,
                  w.comment AS wire_comment
                 FROM lines t
                   LEFT JOIN wires w ON t.wire_id = w.id
                WHERE t.f = true
                ORDER BY t.mesubstation_id, t.id;")   
  end
  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
