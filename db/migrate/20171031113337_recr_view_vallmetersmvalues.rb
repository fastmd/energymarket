class RecrViewVallmetersmvalues < ActiveRecord::Migration[5.0]
  def up
    execute("DROP VIEW public.vallmetersmvalues;")
    execute("CREATE OR REPLACE VIEW public.vallmetersmvalues AS
               SELECT T.*
               , CASE WHEN T.ACTDATE NOT BETWEEN T.RELEVANCE_DATE AND T.RELEVANCE_END THEN TRUE ELSE FALSE END AS ACTDATEFAIL     
               , CASE WHEN T.R AND (COUNT(T.*) OVER (PARTITION BY T.MPOINT_ID, DATE_TRUNC('month',T.ACTDATE),T.R))!=1 THEN TRUE 
                      WHEN NOT(T.R) AND (COUNT(T.*) OVER (PARTITION BY T.MPOINT_ID, DATE_TRUNC('month',T.ACTDATE),T.R))=(COUNT(T.*) OVER (PARTITION BY T.MPOINT_ID, DATE_TRUNC('month',T.ACTDATE))) THEN TRUE 
                      ELSE FALSE END AS FRFAIL      
               , CASE WHEN T.ACTP180<(LAG(T.ACTP180,1,0.0) OVER (PARTITION BY T.ID ORDER BY T.ACTDATE, t.updated_at)) THEN TRUE
                      WHEN T.ACTP280<(LAG(T.ACTP280,1,0.0) OVER (PARTITION BY T.ID ORDER BY T.ACTDATE, t.updated_at)) THEN TRUE
                      WHEN T.ACTP380<(LAG(T.ACTP380,1,0.0) OVER (PARTITION BY T.ID ORDER BY T.ACTDATE, t.updated_at)) THEN TRUE 
                      WHEN T.ACTP480<(LAG(T.ACTP480,1,0.0) OVER (PARTITION BY T.ID ORDER BY T.ACTDATE, t.updated_at)) THEN TRUE
                      ELSE FALSE END AS FZERO       
               FROM (
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
                  t2.actp580,
                  t2.actp880,
                  t2.trab,
                  t2.dwa,
                  t2.r,
                  t2.fanulare,
                  t2.f,
                  t2.comment,
                  t1.f AS meter_f
                 FROM vallmeters t1
                   JOIN mvalues t2 ON t1.id = t2.meter_id
                ORDER BY t1.mpoint_id, t2.actdate, t1.relevance_date, t2.updated_at) T;")                            
  end
  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
