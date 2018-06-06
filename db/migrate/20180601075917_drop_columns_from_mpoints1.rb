class DropColumnsFromMpoints1 < ActiveRecord::Migration[5.0]
  def up
    execute("DROP VIEW public.vmpointsmetersmvalues;")
    execute("DROP VIEW public.vmpointsmeters;")
    execute("DROP VIEW public.vmpointstrparams;")
    execute("DROP VIEW public.vmpointslnparams;")
    execute("DROP VIEW public.vmpoints;")    
    execute("DROP VIEW public.vallmpoints;")
    remove_column :mpoints, :fct
    remove_column :mpoints, :cosfi
    remove_column :mpoints, :fctc
    remove_column :mpoints, :four
    remove_column :mpoints, :fturn
    remove_column :mpoints, :fctl
    remove_column :mpoints, :fmargin
    remove_column :mpoints, :fminuslinelosses    
    execute("CREATE OR REPLACE VIEW public.vallmpoints AS
               SELECT t.*,
                  ( SELECT v.filial_id
                         FROM mesubstations v
                        WHERE v.id = t.mesubstation_id) AS filial_id,
                  ( SELECT v.region_id
                         FROM mesubstations v
                        WHERE v.id = t.mesubstation_id) AS region_id,
                  ( SELECT v.name
                         FROM companies v
                        WHERE t.company_id = v.id) AS company_name,
                  ( SELECT v.shname
                         FROM companies v
                        WHERE t.company_id = v.id) AS company_shname,
                  ( SELECT v.name
                         FROM furnizors v
                        WHERE v.id = t.furnizor_id) AS furnizor_name,
                  ( SELECT f.name
                         FROM mesubstations v,
                          filials f
                        WHERE v.id = t.mesubstation_id AND v.filial_id = f.id) AS filial_name,
                  ( SELECT f.cvalue
                         FROM mesubstations v,
                          thesaurus f
                        WHERE v.id = t.mesubstation_id AND v.region_id = f.id) AS region_name,
                  ( SELECT v.name
                         FROM mesubstations v
                        WHERE v.id = t.mesubstation_id) AS mesubstation_name,                   
                  m.propdate,
                  m.voltcl mproperty_voltcl,
                  m.cosfi,
                  m.fct,
                  m.fctc,
                  m.fctl,
                  m.four,
                  m.fturn,
                  m.fmargin,
                  m.fminuslinelosses,    
                  m.comment as mproperty_comment,
                  m.f as mproperty_f
                 FROM mpoints t left outer join mproperties m on t.id=m.mpoint_id
                ORDER BY  t.company_id, t.id, m.propdate;")
   execute("CREATE OR REPLACE VIEW public.vmpoints AS
             SELECT t.* from vallmpoints t where f=true
              ORDER BY t.company_shname, t.company_id, t.name;")
    execute("CREATE OR REPLACE VIEW public.vmpointslnparams AS
             SELECT t1.id,
                t1.company_id,
                t1.furnizor_id,
                t1.filial_id,
                t1.region_id,
                t1.mesubstation_id,
                t2.mesubstation2_id,
                t2.mesubstation_name,
                t2.mesubstation2_name,
                t1.name,
                t1.cod,
                t1.company_shname company,
                t1.furnizor_name furnizor,
                t1.filial_name filial,
                t1.region_name region,
                t1.mesubstation_name mesubstation,
                t1.meconname,
                t1.voltcl,
                t1.fct,
                t1.fctc,
                t1.fctl,
                t1.cosfi,
                t1.four,
                t1.fturn,
                t1.fmargin,
                t1.fminuslinelosses,
                t1.f,
                t2.id AS ln_id,
                t2.line_id,
                t2.line_name,
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
                t2.unom,
                t2.updated_at,
                t2.f AS ln_f,
                t2.line_f,
                t2.condate,
                t2.condate_end
               FROM vmpoints t1
                 JOIN vlnparams t2 ON t1.id = t2.mpoint_id
              ORDER BY t1.company_shname, t1.id, t2.id;")
    execute("CREATE OR REPLACE VIEW public.vmpointstrparams AS
             SELECT t1.id,
                t1.company_id,
                t1.furnizor_id,
                t1.filial_id,
                t1.region_id,
                t1.mesubstation_id,
                t1.name,
                t1.cod,
                t1.company_name company,
                t1.furnizor_name furnizor,
                t1.filial_name filial,
                t1.region_name region,
                t1.mesubstation_name mesubstation,
                t1.meconname,
                t1.voltcl,
                t1.fct,
                t1.fctc,
                t1.fctl,
                t1.cosfi,
                t1.four,
                t1.fturn,
                t1.fmargin,
                t1.fminuslinelosses,
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
              ORDER BY t1.company_shname, t1.name, t1.id, t2.id;")            
    execute("CREATE OR REPLACE VIEW public.vmpointsmeters AS
             SELECT t1.id,
                t1.company_id,
                t1.furnizor_id,
                t1.filial_id,
                t1.region_id,
                t1.mesubstation_id,
                t1.name,
                t1.cod,
                t1.company_name company,
                t1.furnizor_name furnizor,
                t1.filial_name filial,
                t1.region_name region,
                t1.mesubstation_name mesubstation,
                t1.meconname,
                t1.voltcl,
                t1.fct,
                t1.fctc,
                t1.fctl,
                t1.cosfi,
                t1.four,
                t1.fturn,
                t1.fmargin,
                t1.fminuslinelosses,
                t2.id AS meter_id,
                t2.metertype,
                t2.meternum,
                t2.koeftt,
                t2.koeftn,
                t2.koefcalc,
                t2.comment,
                t2.relevance_date,
                t2.relevance_end,
                t2.beforedigs,
                t2.afterdigs,
                t2.updated_at
               FROM vmpoints t1
                 JOIN vmeters t2 ON t1.id = t2.mpoint_id
              ORDER BY t1.company_shname, t1.name, t1.id, t2.relevance_date, t2.updated_at;") 
    execute("CREATE OR REPLACE VIEW public.vmpointsmetersmvalues AS
             SELECT t.id,
                t.company_id,
                t.furnizor_id,
                t.filial_id,
                t.region_id,
                t.mesubstation_id,
                t.name,
                t.cod,
                t.company,
                t.furnizor,
                t.filial,
                t.region,
                t.mesubstation,
                t.meconname,
                t.voltcl,
                t.fct,
                t.fctc,
                t.fctl,
                t.cosfi,
                t.four,
                t.fturn,
                t.fmargin,
                t.fminuslinelosses,
                t.meter_id,
                t.meternum,
                t.beforedigs,
                t.afterdigs,
                t.actdate,
                t.relevance_date,
                t.mvalue_updated_at,
                t.actp180,
                t.actp280,
                t.actp380,
                t.actp480,
                t.actp580,
                t.actp880,
                t.trab,
                t.dwa,
                t.undercount,
                t.r,
                t.fanulare,
                t.fnefact,
                t.fnozero,
                t.comment,
                    CASE
                        WHEN t.r AND count(t.*) OVER (PARTITION BY t.id, (date_trunc('month'::text, t.actdate::timestamp with time zone)), t.r) <> 1 THEN true
                        WHEN NOT t.r AND count(t.*) OVER (PARTITION BY t.id, (date_trunc('month'::text, t.actdate::timestamp with time zone)), t.r) = count(t.*) OVER (PARTITION BY t.id, (date_trunc('month'::text, t.actdate::timestamp with time zone))) THEN true
                        ELSE false
                    END AS frfail,
                    CASE
                        WHEN t.actp180 < lag(t.actp180, 1, 0.0) OVER (PARTITION BY t.meter_id ORDER BY t.actdate, t.mvalue_updated_at) THEN true
                        WHEN t.actp280 < lag(t.actp280, 1, 0.0) OVER (PARTITION BY t.meter_id ORDER BY t.actdate, t.mvalue_updated_at) THEN true
                        WHEN t.actp380 < lag(t.actp380, 1, 0.0) OVER (PARTITION BY t.meter_id ORDER BY t.actdate, t.mvalue_updated_at) THEN true
                        WHEN t.actp480 < lag(t.actp480, 1, 0.0) OVER (PARTITION BY t.meter_id ORDER BY t.actdate, t.mvalue_updated_at) THEN true
                        ELSE false
                    END AS fzero
               FROM ( SELECT t1.id,
                        t1.company_id,
                        t1.furnizor_id,
                        t1.filial_id,
                        t1.region_id,
                        t1.mesubstation_id,
                        t1.name,
                        t1.cod,
                        t1.company_name company,
                        t1.furnizor_name furnizor,
                        t1.filial_name filial,
                        t1.region_name region,
                        t1.mesubstation_name mesubstation,
                        t1.meconname,
                        t1.voltcl,
                        t1.fct,
                        t1.fctc,
                        t1.fctl,
                        t1.cosfi,
                        t1.four,
                        t1.fturn,
                        t1.fmargin,
                        t1.fminuslinelosses,
                        t2.id AS meter_id,
                        t2.meternum,
                        t2.actdate,
                        t2.relevance_date,
                        t2.mvalue_updated_at,
                        t2.beforedigs,
                        t2.afterdigs,
                        t2.actp180,
                        t2.actp280,
                        t2.actp380,
                        t2.actp480,
                        t2.actp580,
                        t2.actp880,
                        t2.trab,
                        t2.dwa,
                        t2.undercount,
                        t2.r,
                        t2.fanulare,
                        t2.fnefact,
                        t2.fnozero,
                        t2.comment
                       FROM vmpoints t1
                         JOIN vmetersmvalues t2 ON t1.id = t2.mpoint_id
                      ORDER BY t1.company_shname, t1.name, t1.id, t2.actdate, t2.mvalue_updated_at) t;")   
  end
  def down
    raise ActiveRecord::IrreversibleMigration
  end  
end
