class RemakeViewVallmetersmvalues < ActiveRecord::Migration[5.0]
  def up
    execute("DROP VIEW public.vallmetersmvalues;")
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
                  t2.fanulare,
                  t2.f,
                  t2.comment,
                  t1.f meter_f
                 FROM vallmeters t1
                   JOIN mvalues t2 ON t1.id = t2.meter_id
                ORDER BY t1.mpoint_id, t2.actdate,t1.relevance_date,t2.updated_at;")                            
  end
  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
