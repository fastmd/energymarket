class CreateViewMetertypes < ActiveRecord::Migration[5.0]
  def up
    execute("CREATE OR REPLACE VIEW VMETERTYPES AS SELECT T.ID,T.CVALUE FROM thesaurus T WHERE  t.name='meter' and T.F = TRUE ORDER BY T.CVALUE, T.CREATED_AT;")      
  end
  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
