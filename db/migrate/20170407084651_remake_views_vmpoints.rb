class RemakeViewsVmpoints < ActiveRecord::Migration[5.0]
  def up
    execute("DROP VIEW VMPOINTSTRPARAMS;")
    execute("DROP VIEW VMPOINTSLNPARAMS;")
    execute("DROP VIEW VMPOINTSMETERSMVALUES;")    
    execute("DROP VIEW VMPOINTSMETERS;")
    execute("DROP VIEW VMPOINTS;")
    execute("CREATE OR REPLACE VIEW public.vmpoints AS
             SELECT t.id,
                t.company_id,
                t.created_at,
                t.updated_at,
               (SELECT v.cvalue
                     FROM vsstations v
                    WHERE v.id = t.thesauru_id) AS messtation,
                t.meconname,
                t.clsstation,
                t.clconname,
                t.comment,
                t.name,
                t.voltcl,
                t.f,
                t.cod
               FROM mpoints t
              WHERE t.f = true
              ORDER BY t.company_id, t.name;")
    execute("CREATE OR REPLACE VIEW public.vmpointsmeters AS
               SELECT t1.company_id,
                  t1.id,
                  t1.name,
                  t1.cod,
                  t1.messtation,
                  t1.meconname,
                  t1.voltcl,
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
                ORDER BY t1.company_id, t1.name, t1.id, t2.relevance_date, t2.updated_at;")
    execute("CREATE OR REPLACE VIEW public.vmpointsmetersmvalues AS
               SELECT t1.id,
                  t1.company_id,
                  t1.cod,
                  t1.messtation,
                  t1.meconname,
                  t1.voltcl,
                  t2.id AS meter_id,
                  t2.meternum,
                  t2.actdate,
                  t2.mvalue_updated_at,
                  t2.actp180,
                  t2.actp280,
                  t2.actp380,
                  t2.actp480,
                  t2.actp580,
                  t2.actp880,
                  t2.r
                 FROM vmpoints t1
                   JOIN vmetersmvalues t2 ON t1.id = t2.mpoint_id
                ORDER BY t1.company_id, t1.name, t1.id, t2.actdate, t2.mvalue_updated_at;")  
    execute("CREATE OR REPLACE VIEW public.vmpointslnparams AS
               SELECT t1.company_id,
                  t1.id,
                  t1.name,
                  t1.cod,
                  t1.messtation,
                  t1.meconname,
                  t1.voltcl,
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
               SELECT t1.company_id,
                  t1.id,
                  t1.name,
                  t1.cod,
                  t1.messtation,
                  t1.meconname,
                  t1.voltcl,
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
    execute("DROP VIEW public.vsstations;")
    execute("DELETE FROM public.thesaurus WHERE name = 'sstation';")  
  end  
  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
