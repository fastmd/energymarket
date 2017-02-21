class CreateViewVmpointsVmetersVmvalues < ActiveRecord::Migration[5.0]
  def up
    execute("CREATE VIEW VMPOINTSMETERSMVALUES AS 
             SELECT T1.ID, T1.COMPANY_ID, T2.ID METER_ID, T2.METERNUM, T2.ACTDATE, T2.MVALUE_UPDATED_AT, T2.ACTP180, T2.ACTP280, T2.ACTP380, T2.ACTP480      
             FROM VMPOINTS T1 INNER JOIN VMETERSMVALUES T2 ON T1.ID = T2.MPOINT_ID ORDER BY T1.COMPANY_ID, T1.NAME, T1.ID, T2.ACTDATE, T2.MVALUE_UPDATED_AT;")
  end
  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
