class UpdateThesauruidToMpoints < ActiveRecord::Migration[5.0]
  def up
    execute("UPDATE public.mpoints SET thesauru_id = ( select t2.id tid from  public.thesaurus t2 where trim(messtation) = t2.cvalue and t2.name='sstation' ) ;")
  end
  def down
   raise ActiveRecord::IrreversibleMigration
  end 
end
