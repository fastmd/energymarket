class RmakeViewsMeters < ActiveRecord::Migration[5.0]
  def up
    execute("DROP VIEW public.vmpointsmetersmvalues;")
    execute("DROP VIEW public.vmpointsmeters;")
    execute("DROP VIEW public.vmetersmvalues;")
    execute("DROP VIEW public.vmeters;")
    execute("DROP VIEW public.vallmetersmvalues;")
    execute("DROP VIEW public.vallmeters;")
    execute("CREATE OR REPLACE VIEW public.vallmeters AS
               SELECT t.id,
                  t.metertype,
                  t.meternum,
                  t.koeftt,
                  t.koeftn,
                  t.mpoint_id,
                  t.created_at,
                  t.updated_at,
                  t.relevance_date,
                  t.comment,
                  t.f,
                  t.koefcalc,
                  t.beforedigs,
                  t.afterdigs,
                  lead(t.relevance_date, 1, to_date('31/12/3000'::text, 'DD/MM/YYYY'::text)) OVER (PARTITION BY t.mpoint_id ORDER BY t.relevance_date, t.updated_at) AS relevance_end
                 FROM ( SELECT m.id,
                          ( SELECT v.cvalue
                                 FROM vmetertypes v
                                WHERE v.id = m.thesauru_id) AS metertype,
                          m.meternum,
                          m.koeftt,
                          m.koeftn,
                          m.mpoint_id,
                          m.created_at,
                          m.updated_at,
                          m.relevance_date,
                          m.comment,
                          m.f,
                          m.koefcalc,
                          m.beforedigs,
                          m.afterdigs
                         FROM meters m
                        WHERE m.f = true) t
                ORDER BY t.mpoint_id, t.relevance_date, t.updated_at;")    
    execute("CREATE OR REPLACE VIEW public.vallmetersmvalues AS
               SELECT t.id,
                  t.metertype,
                  t.meternum,
                  t.koefcalc,
                  t.relevance_date,
                  t.relevance_end,
                  t.beforedigs,
                  t.afterdigs,
                  t.updated_at,
                  t.mpoint_id,
                  t.mvalue_id,
                  t.actdate,
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
                  t.f,
                  t.comment,
                  t.meter_f,
                      CASE
                          WHEN t.actdate < t.relevance_date OR t.actdate > t.relevance_end THEN true
                          ELSE false
                      END AS actdatefail,
                      CASE
                          WHEN t.r AND count(t.*) OVER (PARTITION BY t.mpoint_id, (date_trunc('month'::text, t.actdate::timestamp with time zone)), t.r) <> 1 THEN true
                          WHEN NOT t.r AND count(t.*) OVER (PARTITION BY t.mpoint_id, (date_trunc('month'::text, t.actdate::timestamp with time zone)), t.r) = count(t.*) OVER (PARTITION BY t.mpoint_id, (date_trunc('month'::text, t.actdate::timestamp with time zone))) THEN true
                          ELSE false
                      END AS frfail,
                      CASE
                          WHEN t.actp180 < lag(t.actp180, 1, 0.0) OVER (PARTITION BY t.id ORDER BY t.actdate, t.updated_at) THEN true
                          WHEN t.actp280 < lag(t.actp280, 1, 0.0) OVER (PARTITION BY t.id ORDER BY t.actdate, t.updated_at) THEN true
                          WHEN t.actp380 < lag(t.actp380, 1, 0.0) OVER (PARTITION BY t.id ORDER BY t.actdate, t.updated_at) THEN true
                          WHEN t.actp480 < lag(t.actp480, 1, 0.0) OVER (PARTITION BY t.id ORDER BY t.actdate, t.updated_at) THEN true
                          ELSE false
                      END AS fzero
                 FROM ( SELECT t1.id,
                          t1.metertype,
                          t1.meternum,
                          t1.koefcalc,
                          t1.relevance_date,
                          t1.relevance_end,
                          t1.updated_at,
                          t1.mpoint_id,
                          t2.id AS mvalue_id,
                          t2.actdate,
                          t2.updated_at AS mvalue_updated_at,
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
                          t2.f,
                          t2.comment,
                          t1.f AS meter_f,
                          t1.beforedigs,
                          t1.afterdigs
                         FROM vallmeters t1
                           JOIN mvalues t2 ON t1.id = t2.meter_id
                        ORDER BY t1.mpoint_id, t2.actdate, t1.relevance_date, t2.updated_at) t;")
    execute("CREATE OR REPLACE VIEW public.vmeters AS
               SELECT t.id,
                  t.metertype,
                  t.meternum,
                  t.koeftt,
                  t.koeftn,
                  t.mpoint_id,
                  t.created_at,
                  t.updated_at,
                  t.relevance_date,
                  t.comment,
                  t.f,
                  t.koefcalc,
                  t.beforedigs,
                  t.afterdigs,
                  lead(t.relevance_date, 1, to_date('31/12/3000'::text, 'DD/MM/YYYY'::text)) OVER (PARTITION BY t.mpoint_id ORDER BY t.relevance_date, t.updated_at) AS relevance_end
                 FROM ( SELECT m.id,
                          ( SELECT v.cvalue
                                 FROM vmetertypes v
                                WHERE v.id = m.thesauru_id) AS metertype,
                          m.meternum,
                          m.koeftt,
                          m.koeftn,
                          m.mpoint_id,
                          m.created_at,
                          m.updated_at,
                          m.relevance_date,
                          m.comment,
                          m.f,
                          m.koefcalc,
                          m.beforedigs,
                          m.afterdigs
                         FROM meters m
                        WHERE m.f = true) t
                ORDER BY t.mpoint_id, t.relevance_date, t.updated_at;")                  
    execute("CREATE OR REPLACE VIEW public.vmetersmvalues AS
               SELECT t1.id,
                  t1.metertype,
                  t1.meternum,
                  t1.koefcalc,
                  t1.relevance_date,
                  t1.relevance_end,
                  t1.updated_at,
                  t1.mpoint_id,
                  t1.beforedigs,
                  t1.afterdigs,
                  t2.id AS mvalue_id,
                  t2.actdate,
                  t2.updated_at AS mvalue_updated_at,
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
                 FROM vmeters t1
                   JOIN vmvalues t2 ON t1.id = t2.meter_id AND t2.actdate >= t1.relevance_date AND t2.actdate <= t1.relevance_end
                ORDER BY t1.mpoint_id, t2.actdate, t2.updated_at;")              
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
