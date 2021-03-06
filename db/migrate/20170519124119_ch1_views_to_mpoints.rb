class Ch1ViewsToMpoints < ActiveRecord::Migration[5.0]
  def up
    execute("DROP VIEW vmpointsmetersmvalues;")     
    execute("DROP VIEW vmpointsmeters;")     
    execute("DROP VIEW vmpointstrparams;")    
    execute("DROP VIEW vmpointslnparams;")
    execute("DROP VIEW vmpoints;")
    execute("CREATE OR REPLACE VIEW public.vmpoints AS
             SELECT t.id,
                t.company_id,
                t.furnizor_id,
                ( SELECT v.filial_id
                       FROM mesubstations v
                      WHERE v.id = t.mesubstation_id) AS filial_id,
                ( SELECT v.region_id
                       FROM mesubstations v
                      WHERE v.id = t.mesubstation_id) AS region_id,
                t.mesubstation_id,
                ( SELECT v.name
                       FROM companies v
                      WHERE t.company_id = v.id) AS company,
                ( SELECT v.name
                       FROM furnizors v
                      WHERE v.id = t.furnizor_id) AS furnizor,
                ( SELECT f.name
                       FROM mesubstations v,
                        filials f
                      WHERE v.id = t.mesubstation_id AND v.filial_id = f.id) AS filial,
                ( SELECT f.cvalue
                       FROM mesubstations v,
                        thesaurus f
                      WHERE v.id = t.mesubstation_id AND v.region_id = f.id) AS region,
                ( SELECT v.name
                       FROM mesubstations v
                      WHERE v.id = t.mesubstation_id) AS mesubstation,
                t.meconname,
                t.clsstation,
                t.clconname,
                t.name,
                t.cod,
                t.voltcl,
                t.f,
                t.fct,
                t.comment,
                t.created_at,
                t.updated_at
               FROM mpoints t
              WHERE t.f = true
              ORDER BY t.company_id, t.name;")
    execute("CREATE OR REPLACE VIEW public.vmpointslnparams AS
             SELECT t1.id,
                t1.company_id,
                t1.furnizor_id,
                t1.filial_id,
                t1.region_id,
                t1.mesubstation_id,
                t1.name,
                t1.cod,
                t1.company,
                t1.furnizor,
                t1.filial,
                t1.region,
                t1.mesubstation,
                t1.meconname,
                t1.voltcl,
                t1.fct,
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
              ORDER BY t1.company, t1.name, t1.id, t2.id;")
    execute("CREATE OR REPLACE VIEW public.vmpointstrparams AS
             SELECT t1.id,
                t1.company_id,
                t1.furnizor_id,
                t1.filial_id,
                t1.region_id,
                t1.mesubstation_id,
                t1.name,
                t1.cod,
                t1.company,
                t1.furnizor,
                t1.filial,
                t1.region,
                t1.mesubstation,
                t1.meconname,
                t1.voltcl,
                t1.fct,
                t2.id AS tr_id,
                t2.name AS transformator_name,
                t2.mark,
                t2.unom,
                t2.snom,
                t2.pxx,
                t2.pkz,
                t2.ukz,
                t2.i0,
                t2.io,
                t2.qkz,
                t2.comment,
                t2.updated_at
               FROM vmpoints t1
                 JOIN vtrparams t2 ON t1.id = t2.mpoint_id
              ORDER BY t1.company, t1.name, t1.id, t2.id;")                            
    execute("CREATE OR REPLACE VIEW public.vmpointsmeters AS
             SELECT t1.id,
                t1.company_id,
                t1.furnizor_id,
                t1.filial_id,
                t1.region_id,
                t1.mesubstation_id,
                t1.name,
                t1.cod,
                t1.company,
                t1.furnizor,
                t1.filial,
                t1.region,
                t1.mesubstation,
                t1.meconname,
                t1.voltcl,
                t1.fct,
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
              ORDER BY t1.company, t1.name, t1.id, t2.relevance_date, t2.updated_at;")
    execute("CREATE OR REPLACE VIEW public.vmpointsmetersmvalues AS
             SELECT t1.id,
                t1.company_id,
                t1.furnizor_id,
                t1.filial_id,
                t1.region_id,
                t1.mesubstation_id,
                t1.name,
                t1.cod,
                t1.company,
                t1.furnizor,
                t1.filial,
                t1.region,
                t1.mesubstation,
                t1.meconname,
                t1.voltcl,
                t1.fct,
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
              ORDER BY t1.company, t1.name, t1.id, t2.actdate, t2.mvalue_updated_at;")                                                              
  end
  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
