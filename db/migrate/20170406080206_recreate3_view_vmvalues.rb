class Recreate3ViewVmvalues < ActiveRecord::Migration[5.0]
  def up
    execute("DROP VIEW VMPOINTSMETERSMVALUES;")    
    execute("DROP VIEW VMETERSMVALUES;")
    execute("DROP VIEW VMVALUES;")
    execute("CREATE OR REPLACE VIEW VMVALUES AS SELECT T.* FROM MVALUES T WHERE F = TRUE ORDER BY METER_ID, ACTDATE, UPDATED_AT;")
    execute("CREATE OR REPLACE VIEW public.vmetersmvalues AS
              SELECT  t1.id,
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
                      t2.r
              FROM vmeters t1
                    JOIN vmvalues t2 ON t1.id = t2.meter_id AND t2.actdate >= t1.relevance_date AND t2.actdate <= t1.relevance_end
              ORDER BY t1.mpoint_id, t2.actdate, t2.updated_at;")
    execute("CREATE OR REPLACE VIEW public.vmpointsmetersmvalues AS
                 SELECT t1.id,
                    t1.company_id,
                    t1.cod,
                    t1.messtation,
                    t1.meconname,
                    t1.voltcl,
                    t2.id AS meter_id,
                    t2.meternum,
                    t2.actdate,
                    t2.mvalue_updated_at,
                    t2.actp180,
                    t2.actp280,
                    t2.actp380,
                    t2.actp480,
                    t2.actp580,
                    t2.actp880,                    
                    t2.r
                   FROM vmpoints t1
                     JOIN vmetersmvalues t2 ON t1.id = t2.mpoint_id
                  ORDER BY t1.company_id, t1.name, t1.id, t2.actdate, t2.mvalue_updated_at;")             
  end
  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
