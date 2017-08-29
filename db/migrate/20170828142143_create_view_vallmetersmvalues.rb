class CreateViewVallmetersmvalues < ActiveRecord::Migration[5.0]
  def up
    execute("CREATE OR REPLACE VIEW public.vallmeters AS
               SELECT t.id,
                  t.metertype,
                  t.meternum,
                  t.koeftt,
                  t.koeftn,
                  t.mpoint_id,
                  t.created_at,
                  t.updated_at,
                  t.relevance_date,
                  t.comment,
                  t.f,
                  t.koefcalc,
                  lead(t.relevance_date, 1, to_date('31/12/3000'::text, 'DD/MM/YYYY'::text)) OVER (PARTITION BY t.mpoint_id ORDER BY t.relevance_date, t.updated_at) AS relevance_end
                 FROM ( SELECT m.id,
                          ( SELECT v.cvalue
                                 FROM vmetertypes v
                                WHERE v.id = m.thesauru_id) AS metertype,
                          m.meternum,
                          m.koeftt,
                          m.koeftn,
                          m.mpoint_id,
                          m.created_at,
                          m.updated_at,
                          m.relevance_date,
                          m.comment,
                          m.f,
                          m.koefcalc
                         FROM meters m
                        WHERE m.f = true) t
                ORDER BY t.mpoint_id, t.relevance_date, t.updated_at;")
    execute("CREATE OR REPLACE VIEW public.vallmetersmvalues AS
               SELECT t1.id,
                  t1.metertype,
                  t1.meternum,
                  t1.koefcalc,
                  t1.relevance_date,
                  t1.relevance_end,
                  t1.updated_at,
                  t1.mpoint_id,
                  t2.id AS mvalue_id,
                  t2.actdate,
                  t2.updated_at AS mvalue_updated_at,
                  t2.actp180,
                  t2.actp280,
                  t2.actp380,
                  t2.actp480,
                  t2.actp580,
                  t2.actp880,
                  t2.trab,
                  t2.dwa,
                  t2.r,
                  t2.fanulare
                 FROM vallmeters t1
                   JOIN mvalues t2 ON t1.id = t2.meter_id
                ORDER BY t1.mpoint_id, t2.actdate,t1.relevance_date,t2.updated_at;")                            
  end
  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
