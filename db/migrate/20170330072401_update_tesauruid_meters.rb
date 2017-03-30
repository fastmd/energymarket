class UpdateTesauruidMeters < ActiveRecord::Migration[5.0]
  def up
    execute("UPDATE public.meters SET 
               thesauru_id =  ( select t2.id tid from  public.thesaurus t2 where trim(metertype) = t2.cvalue ) ;")
  end
  def down
        raise ActiveRecord::IrreversibleMigration
  end 
end
