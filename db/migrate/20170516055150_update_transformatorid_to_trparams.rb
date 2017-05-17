class UpdateTransformatoridToTrparams < ActiveRecord::Migration[5.0]
  def up
    execute("UPDATE public.trparams
              SET transformator_id=s.id
              FROM 
              (SELECT t.* FROM transformators t 
              ) AS s
              WHERE public.trparams.pxx=s.pxx and public.trparams.pkz=s.pkz and  public.trparams.snom=s.snom
               and  public.trparams.ukz=s.ukz and public.trparams.io=s.i0   and  public.trparams.qkz=s.qkz; ")               
  end
  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
