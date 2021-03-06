class RecreateViewVmvalues < ActiveRecord::Migration[5.0]
  def up
    execute("DROP VIEW VMPOINTSMETERSMVALUES;")    
    execute("DROP VIEW VMETERSMVALUES;")
    execute("DROP VIEW VMVALUES;")
    execute("CREATE OR REPLACE VIEW VMVALUES AS SELECT T.* FROM MVALUES T WHERE F = TRUE ORDER BY METER_ID, ACTDATE, UPDATED_AT;")
    execute("CREATE VIEW VMETERSMVALUES AS 
             SELECT T1.ID ID, T1.METERTYPE, T1.METERNUM, T1.KOEFCALC, T1.RELEVANCE_DATE, T1.RELEVANCE_END, T1.UPDATED_AT, T1.MPOINT_ID,    
             T2.ID MVALUE_ID, T2.ACTDATE, T2.UPDATED_AT MVALUE_UPDATED_AT, T2.ACTP180, T2.ACTP280, T2.ACTP380, T2.ACTP480, T2.R 
             FROM VMETERS T1 INNER JOIN VMVALUES T2 ON T1.ID=T2.METER_ID AND (T2.ACTDATE BETWEEN T1.RELEVANCE_DATE AND T1.RELEVANCE_END) 
             ORDER BY T1.MPOINT_ID, T2.ACTDATE, T2.UPDATED_AT;")
    execute("CREATE VIEW VMPOINTSMETERSMVALUES AS 
             SELECT T1.ID, T1.COMPANY_ID, T2.ID METER_ID, T2.METERNUM, T2.ACTDATE, T2.MVALUE_UPDATED_AT, T2.ACTP180, T2.ACTP280, T2.ACTP380, T2.ACTP480, T2.R      
             FROM VMPOINTS T1 INNER JOIN VMETERSMVALUES T2 ON T1.ID = T2.MPOINT_ID ORDER BY T1.COMPANY_ID, T1.NAME, T1.ID, T2.ACTDATE, T2.MVALUE_UPDATED_AT;")             
  end
  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
