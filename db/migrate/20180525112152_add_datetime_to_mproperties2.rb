class AddDatetimeToMproperties2 < ActiveRecord::Migration[5.0]
  def up
    execute("INSERT INTO public.MPROPERTIES 
             (id,mpoint_id,voltcl,fct,cosfi,fctc,four,fturn,fctl,fmargin,fminuslinelosses,f,comment,created_at,updated_at,propdate) 
             SELECT  (nextval('mproperties_id_seq')),id,voltcl,fct,cosfi,fctc,four,fturn,fctl,fmargin,fminuslinelosses,f,comment,'01/01/2016','01/01/2016','01/01/2016' 
                 FROM public.MPOINTS;")                                             
  end
  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
