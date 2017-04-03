class Create1ViewVmeters < ActiveRecord::Migration[5.0]
  def up
    execute("DROP VIEW public.vmpointsmetersmvalues;")
    execute("DROP VIEW public.vmpointsmeters;")
    execute("DROP VIEW public.vmetersmvalues;")
    execute("DROP VIEW VMETERS;")
    execute("CREATE OR REPLACE VIEW VMETERS AS  SELECT t.id,
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
    lead(t.relevance_date, 1, to_date('31/12/3000'::text, 'DD/MM/YYYY'::text)) OVER (PARTITION BY t.mpoint_id ORDER BY t.relevance_date, t.updated_at) AS relevance_end
   FROM ( SELECT m.id,
            (SELECT v.cvalue FROM public.vmetertypes v where v.id = m.thesauru_id) metertype,
            m.meternum,
            m.koeftt,
            m.koeftn,
            m.mpoint_id,
            m.created_at,
            m.updated_at,
            m.relevance_date,
            m.comment,
            m.f,
            m.koefcalc
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
    t2.id AS mvalue_id,
    t2.actdate,
    t2.updated_at AS mvalue_updated_at,
    t2.actp180,
    t2.actp280,
    t2.actp380,
    t2.actp480,
    t2.r
   FROM vmeters t1
     JOIN vmvalues t2 ON t1.id = t2.meter_id AND t2.actdate >= t1.relevance_date AND t2.actdate <= t1.relevance_end
  ORDER BY t1.mpoint_id, t2.actdate, t2.updated_at;")
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
  ORDER BY t1.company_id, t1.name, t1.id, t2.relevance_date, t2.updated_at;
;")
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
    t2.r
   FROM vmpoints t1
     JOIN vmetersmvalues t2 ON t1.id = t2.mpoint_id
  ORDER BY t1.company_id, t1.name, t1.id, t2.actdate, t2.mvalue_updated_at;")
  end
  def down
    raise ActiveRecord::IrreversibleMigration
  end 
end
