class UpdateFilialfurnizoridToMpoint < ActiveRecord::Migration[5.0]
  def up
    execute("UPDATE public.mpoints mp SET filial_id = ( SELECT c.filial_id FROM mpoints m left outer join companies c on m.company_id=c.id where m.id = mp.id) ;")
    execute("UPDATE public.mpoints mp SET furnizor_id = ( SELECT c.furnizor_id FROM mpoints m left outer join companies c on m.company_id=c.id where m.id = mp.id) ;")  
  end
  def down
    raise ActiveRecord::IrreversibleMigration
  end 
end
