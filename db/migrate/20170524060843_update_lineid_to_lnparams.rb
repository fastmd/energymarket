class UpdateLineidToLnparams < ActiveRecord::Migration[5.0]
  def up
    execute("UPDATE public.lnparams ln
              SET line_id=s.id
              FROM 
              (SELECT l.id, l.mesubstation_id, l.l, l.r, l.k_tr, l.k_f, w.name, w.ro, w.k_scr, w.k_peb, w.q FROM lines l inner join wires w on l.wire_id=w.id) AS s
              WHERE (select m.mesubstation_id from mpoints m where ln.mpoint_id=m.id)=s.mesubstation_id and ln.l=s.l and  ln.r=s.r
               and  ln.k_tr=s.k_tr and ln.k_f=s.k_f   and  trim(ln.mark)=s.name and ln.ro=s.ro 
               and  ln.k_scr=s.k_scr  and ln.k_peb=s.k_peb  and ln.q=s.q; ")                                                 
  end
  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
