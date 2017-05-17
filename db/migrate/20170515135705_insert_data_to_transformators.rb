class InsertDataToTransformators < ActiveRecord::Migration[5.0]
  def up
    execute("INSERT INTO public.transformators (name, pxx, pkz, snom, ukz, i0, qkz, f, created_at, updated_at) 
               (select 'mark' as name, t.pxx, t.pkz, t.snom, t.ukz, t.io as i0, t.qkz, true as f, CURRENT_TIMESTAMP as created_at, CURRENT_TIMESTAMP as updated_at 
               from (SELECT  distinct pxx, pkz, snom, ukz, io, qkz FROM public.trparams) t );")                        
  end
  def down
    raise ActiveRecord::IrreversibleMigration
  end 
end
