class UpdateDataMesubstations < ActiveRecord::Migration[5.0]
  def up
    execute("UPDATE public.mesubstations
              SET filial_id=subquery.filial_id
              FROM
              (SELECT mp.*, ss.* FROM MPOINTS as MP LEFT OUTER JOIN 
              (SELECT ss.id ss_id, th.id th_id FROM public.mesubstations ss left outer join public.thesaurus th on ss.name = th.cvalue where th.name = 'sstation') as  SS
              ON MP.thesauru_id = ss.th_id WHERE MP.FILIAL_ID IS NOT NULL) AS subquery
              WHERE public.mesubstations.id=subquery.ss_id; ")
    execute("UPDATE public.mesubstations
              SET region_id=subquery.region_id
              FROM
              (SELECT T1.SS_ID,CMP.THESAURU_ID REGION_ID FROM 
              (SELECT mp.*, ss.* FROM MPOINTS as MP LEFT OUTER JOIN 
              (SELECT ss.id ss_id, th.id th_id FROM public.mesubstations ss left outer join public.thesaurus th on ss.name = th.cvalue where th.name = 'sstation') as  SS
              ON MP.thesauru_id = ss.th_id) T1
              LEFT OUTER JOIN public.companies CMP ON T1.COMPANY_ID=CMP.ID WHERE CMP.THESAURU_ID IS NOT NULL 
              ) AS subquery
              WHERE public.mesubstations.id=subquery.ss_id; ")                                       
  end
  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
