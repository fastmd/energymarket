class RecreateViewVmpoints < ActiveRecord::Migration[5.0]
  def up
    execute("DROP VIEW VMPOINTSMETERSMVALUES;")    
    execute("DROP VIEW VMPOINTSMETERS;")
    execute("DROP VIEW VMPOINTS;")
    execute("CREATE OR REPLACE VIEW VMPOINTS AS SELECT T.* FROM MPOINTS T WHERE F = TRUE ORDER BY COMPANY_ID, NAME;")
    execute("CREATE OR REPLACE VIEW public.vmpointsmeters AS
             SELECT 
                t1.company_id,
                t1.id,
                t1.name,
                t1.cod,
                t2.id AS meter_id,
                t2.metertype,
                t2.meternum,
                t2.koeftt,
                t2.koeftn,
                t2.koefcalc,    
                t2.comment,
                t2.relevance_date,
                t2.relevance_end,
                t2.updated_at    
               FROM vmpoints t1
                 JOIN vmeters t2 ON t1.id = t2.mpoint_id
              ORDER BY t1.company_id, t1.name, t1.id, t2.relevance_date,t2.updated_at;")
    execute("CREATE VIEW VMPOINTSMETERSMVALUES AS 
             SELECT T1.ID, T1.COMPANY_ID, T1.COD, T2.ID METER_ID, T2.METERNUM, T2.ACTDATE, T2.MVALUE_UPDATED_AT, T2.ACTP180, T2.ACTP280, T2.ACTP380, T2.ACTP480, T2.R      
             FROM VMPOINTS T1 INNER JOIN VMETERSMVALUES T2 ON T1.ID = T2.MPOINT_ID ORDER BY T1.COMPANY_ID, T1.NAME, T1.ID, T2.ACTDATE, T2.MVALUE_UPDATED_AT;")             
  end
  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
