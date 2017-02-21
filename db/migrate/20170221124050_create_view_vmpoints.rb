class CreateViewVmpoints < ActiveRecord::Migration[5.0]
  def up
    execute("CREATE OR REPLACE VIEW VMPOINTS AS SELECT T.* FROM MPOINTS T WHERE F = TRUE ORDER BY COMPANY_ID, NAME;")
  end
  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
