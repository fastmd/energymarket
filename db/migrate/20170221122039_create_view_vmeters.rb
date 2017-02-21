class CreateViewVmeters < ActiveRecord::Migration[5.0]
  def up
    execute("CREATE OR REPLACE VIEW VMETERS AS SELECT T.*, LEAD(RELEVANCE_DATE, 1, TO_DATE('31/12/3000','DD/MM/YYYY')) OVER (PARTITION BY MPOINT_ID ORDER BY RELEVANCE_DATE, UPDATED_AT) AS RELEVANCE_END
             FROM (SELECT M.* FROM METERS M WHERE F = TRUE) T ORDER BY MPOINT_ID, RELEVANCE_DATE, UPDATED_AT;")
  end
  def down
    raise ActiveRecord::IrreversibleMigration
  end 
end
