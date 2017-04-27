class UpdateMesubstationidMpoints < ActiveRecord::Migration[5.0]
  def up
    execute("UPDATE public.mpoints
              SET mesubstation_id=subquery.ss_id
              FROM 
              (SELECT mp.*, ss.* FROM MPOINTS as MP LEFT OUTER JOIN 
              (SELECT ss.id ss_id, th.id th_id FROM public.mesubstations ss left outer join public.thesaurus th on ss.name = th.cvalue where th.name = 'sstation') as  SS
              ON MP.thesauru_id = ss.th_id
              ) AS subquery
              WHERE public.mpoints.id=subquery.id; ")
  end
  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
