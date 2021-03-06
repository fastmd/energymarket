class Update1TesauruidMeters < ActiveRecord::Migration[5.0]
  def up
    execute("UPDATE 
              public.meters
             SET 
              thesauru_id =   
                  ( select t2.id tid from  public.thesaurus t2 where case trim(metertype) when 'MT-831-T1A' then 'MT831-T1A'
                                                                                          when 'MT-831-T1' then 'MT831-T1'
                                                                                          else  trim(metertype) end
                        = t2.cvalue ) 
           ;")
  end
  def down
        raise ActiveRecord::IrreversibleMigration
  end 
end
