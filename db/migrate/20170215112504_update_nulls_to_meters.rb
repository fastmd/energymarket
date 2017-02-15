class UpdateNullsToMeters < ActiveRecord::Migration[5.0]
  def up
    execute("UPDATE public.meters SET koeftn = '1 / 1' WHERE koeftn is null;")
    execute("UPDATE public.meters SET koeftt = '1 / 1' WHERE koeftt is null;")
    execute("UPDATE public.meters SET metertype = 'ZMD' WHERE metertype is null;")
    execute("UPDATE public.meters SET meternum = 1 WHERE meternum is null;")
    execute("UPDATE public.meters SET relevance_date = '01/01/2016' WHERE relevance_date is null;")
    execute("UPDATE public.meters SET f = true WHERE f is null;")    
  end
  def down
        raise ActiveRecord::IrreversibleMigration
  end
end
