class CreateViewVmpointsmeters < ActiveRecord::Migration[5.0]
  def up
    execute("CREATE OR REPLACE VIEW public.vmpointsmeters AS
             SELECT 
                t1.company_id,
                t1.id,
                t1.name,
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
  end
  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
