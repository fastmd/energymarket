class UpdateDataToTransformators < ActiveRecord::Migration[5.0]
  def up
    execute("UPDATE public.transformators
              SET name=s.mark
              FROM 
              (SELECT t.* FROM trparams t where t.mark is not null and trim(t.mark) is not null
              ) AS s
              WHERE public.transformators.pxx=s.pxx and public.transformators.pkz=s.pkz and  public.transformators.snom=s.snom
               and  public.transformators.ukz=s.ukz  and  public.transformators.i0=s.io  and  public.transformators.qkz=s.qkz; ")
    execute("UPDATE public.transformators
              SET comment=s.comment
              FROM 
              (SELECT t.* FROM trparams t where t.comment is not null and trim(t.comment) is not null
              ) AS s
              WHERE public.transformators.pxx=s.pxx and public.transformators.pkz=s.pkz and  public.transformators.snom=s.snom
               and  public.transformators.ukz=s.ukz  and  public.transformators.i0=s.io  and  public.transformators.qkz=s.qkz; ")               
  end
  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
