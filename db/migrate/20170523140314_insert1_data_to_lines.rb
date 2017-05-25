class Insert1DataToLines < ActiveRecord::Migration[5.0]
  def up
    execute("UPDATE public.lnparams l SET r = round(l.k_scr*l.k_tr*l.k_peb*l.ro*l.l*1000/COALESCE(l.q,1),8);")
    execute("INSERT INTO public.lines ( name, l, r, k_tr, k_f, mesubstation_id, wire_id, f, created_at, updated_at) 
               (select (select m.name from public.mesubstations m where m.id=t.mesubstation_id) as name, l, r, k_tr, k_f, mesubstation_id
               ,(select w.id from public.wires w where w.ro=t.ro and w.name=trim(t.mark) and w.k_peb=t.k_peb and w.q=t.q and w.k_scr=t.k_scr limit 1) wire_id
               , true as f, CURRENT_TIMESTAMP as created_at, CURRENT_TIMESTAMP as updated_at 
               from (select distinct l,r,(select m.mesubstation_id from public.mpoints m where m.id=t.mpoint_id) mesubstation_id,ro,k_scr,k_tr,k_peb,q,k_f,trim(mark) mark FROM public.lnparams t) t);")                        
  end
  def down
    raise ActiveRecord::IrreversibleMigration
  end    
end
