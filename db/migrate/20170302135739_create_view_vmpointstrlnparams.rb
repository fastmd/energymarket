class CreateViewVmpointstrlnparams < ActiveRecord::Migration[5.0]
  def up
    execute("CREATE OR REPLACE VIEW public.vmpointslnparams AS
             SELECT 
                t1.company_id,
                t1.id,
                t1.name,
                t1.cod,
                t2.id AS ln_id,
                t2.l,
                t2.r,
                t2.ro,
                t2.k_scr,
                t2.k_tr,    
                t2.comment,
                t2.k_peb,
                t2.q,
                t2.k_f,
                t2.mark,
                t2.updated_at    
               FROM vmpoints t1
                 JOIN vlnparams t2 ON t1.id = t2.mpoint_id
              ORDER BY t1.company_id, t1.name, t1.id, t2.id;")
    execute("CREATE OR REPLACE VIEW public.vmpointstrparams AS
             SELECT 
                t1.company_id,
                t1.id,
                t1.name,
                t1.cod,
                t2.id AS tr_id,
                t2.pxx,
                t2.pkz,
                t2.snom,
                t2.ukz,
                t2.io,    
                t2.qkz,
                t2.mark,
                t2.comment,                
                t2.updated_at    
               FROM vmpoints t1
                 JOIN vtrparams t2 ON t1.id = t2.mpoint_id
              ORDER BY t1.company_id, t1.name, t1.id, t2.id;")  
  end
  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
