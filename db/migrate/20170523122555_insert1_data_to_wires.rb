class Insert1DataToWires < ActiveRecord::Migration[5.0]
  def up
    execute("UPDATE public.lnparams SET k_f = 1.15;")
    execute("UPDATE public.lnparams SET k_tr = 1.03;")
    execute("UPDATE public.lnparams SET mark = 'провод' where trim(mark) is null or trim(mark)='';")   
    execute("INSERT INTO public.wires ( name, ro, k_scr, k_peb, q, f, created_at, updated_at) 
               (select name, ro, k_scr, k_peb, q, true as f, CURRENT_TIMESTAMP as created_at, CURRENT_TIMESTAMP as updated_at 
               from (SELECT  distinct trim(mark) as name, ro, k_scr, k_peb, q FROM public.lnparams) t );")                        
  end
  def down
    raise ActiveRecord::IrreversibleMigration
  end  
end
