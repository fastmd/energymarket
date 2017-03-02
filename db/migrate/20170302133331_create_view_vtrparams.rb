class CreateViewVtrparams < ActiveRecord::Migration[5.0]
  def up
    execute("CREATE OR REPLACE VIEW VTRPARAMS AS SELECT T.* FROM TRPARAMS T WHERE F = TRUE ORDER BY MPOINT_ID, ID;")
    execute("CREATE OR REPLACE VIEW VLNPARAMS AS SELECT T.* FROM LNPARAMS T WHERE F = TRUE ORDER BY MPOINT_ID, ID;")           
  end
  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
