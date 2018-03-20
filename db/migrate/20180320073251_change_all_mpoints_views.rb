class ChangeAllMpointsViews < ActiveRecord::Migration[5.0]
  def up    
    execute("DROP VIEW public.vmpointsmetersmvalues;")
    execute("DROP VIEW public.vmpointsmeters;")
    execute("DROP VIEW public.vmpointstrparams;")
    execute("DROP VIEW public.vmpointslnparams;")
    execute("DROP VIEW public.vmpoints;")
    execute("DROP VIEW public.vallmpoints;")
    execute("CREATE OR REPLACE VIEW public.vallmpoints AS
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
                t.meconname,
                t.clsstation,
                t.clconname,
                t.name,
                t.cod,
                t.voltcl,
                t.cosfi,
                t.f,
                t.fct,
                t.fctc,
                t.fctl,
                t.four,
                t.fturn,
                t.fmargin,
                t.fminuslinelosses,
                t.comment,
                t.created_at,
                t.updated_at
               FROM mpoints t
              ORDER BY t.company_id, t.name;")
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
                t.fctc,
                t.fctl,
                t.cosfi,
                t.four,
                t.fturn,
                t.fmargin,
                t.fminuslinelosses,
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
                t2.mesubstation2_id,
                t2.mesubstation_name,
                t2.mesubstation2_name,
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
              ORDER BY t1.company, t1.id, t2.id;")
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
              ORDER BY t1.company, t1.name, t1.id, t2.relevance_date, t2.updated_at;") 
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
                        t1.company,
                        t1.furnizor,
                        t1.filial,
                        t1.region,
                        t1.mesubstation,
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
                      ORDER BY t1.company, t1.name, t1.id, t2.actdate, t2.mvalue_updated_at) t;")               
  end
  def down
    raise ActiveRecord::IrreversibleMigration
  end    
end
