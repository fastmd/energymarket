class CreateViewVmvalues < ActiveRecord::Migration[5.0]
  def up
    execute("CREATE OR REPLACE VIEW VMVALUES AS SELECT T.* FROM MVALUES T WHERE F = TRUE ORDER BY METER_ID, ACTDATE, UPDATED_AT;")
  end
  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
